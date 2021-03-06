/* ****************************************************************** **
**    OpenSees - Open System for Earthquake Engineering Simulation    **
**          Pacific Earthquake Engineering Research Center            **
**                                                                    **
**                                                                    **
** (C) Copyright 1999, The Regents of the University of California    **
** All Rights Reserved.                                               **
**                                                                    **
** Commercial use of this program without express permission of the   **
** University of California, Berkeley, is strictly prohibited.  See   **
** file 'COPYRIGHT'  in main directory for information on usage and   **
** redistribution,  and for a DISCLAIMER OF ALL WARRANTIES.           **
**                                                                    **
** Developed by:                                                      **
**   Frank McKenna (fmckenna@ce.berkeley.edu)                         **
**   Gregory L. Fenves (fenves@ce.berkeley.edu)                       **
**   Filip C. Filippou (filippou@ce.berkeley.edu)                     **
**                                                                    **
** ****************************************************************** */
                                                                        
// $Revision: 1.6 $
// $Date: 2003-02-14 23:01:38 $
// $Source: /usr/local/cvs/OpenSees/SRC/material/uniaxial/ElasticPPMaterial.cpp,v $
                                                                        
// Written: fmk 
// Created: 07/98
// Revision: A
//
// Description: This file contains the class implementation for 
// ElasticMaterial. 
//
// What: "@(#) ElasticPPMaterial.C, revA"


#include <ElasticPPMaterial.h>
#include <Vector.h>
#include <Channel.h>
#include <math.h>
#include <float.h>

#include <elementAPI.h>

//theMaterial = new ElasticPPMaterial(iData[0], dData[0], dData[1], dData[2], dData[3]);


ElasticPPMaterial::ElasticPPMaterial(int tag, double e, double eyp)
:UniaxialMaterial(tag,MAT_TAG_ElasticPPMaterial),
 ezero(0.0), E(e), ep(0.0),
 trialStrain(0.0), trialStress(0.0), trialTangent(E),
 commitStrain(0.0), commitStress(0.0), commitTangent(E)
{
  fyp = E*eyp;
  fyn = -fyp;
}

ElasticPPMaterial::ElasticPPMaterial(int tag, double e, double eyp,
				     double eyn, double ez )
:UniaxialMaterial(tag,MAT_TAG_ElasticPPMaterial),
 ezero(ez), E(e), ep(0.0),
 trialStrain(0.0), trialStress(0.0), trialTangent(E),
 commitStrain(0.0), commitStress(0.0), commitTangent(E)
{
    if (eyp < 0) {
	opserr << "ElasticPPMaterial::ElasticPPMaterial() - eyp < 0, setting > 0\n";
	eyp *= -1.;
    }
    if (eyn > 0) {
	opserr << "ElasticPPMaterial::ElasticPPMaterial() - eyn > 0, setting < 0\n";
	eyn *= -1.;
    }    
    
    fyp = E*eyp;
    fyn = E*eyn;
}

ElasticPPMaterial::ElasticPPMaterial()
:UniaxialMaterial(0,MAT_TAG_ElasticPPMaterial),
 fyp(0.0), fyn(0.0), ezero(0.0), E(0.0), ep(0.0), 
 trialStrain(0.0), trialStress(0.0), trialTangent(0.0),
 commitStrain(0.0), commitStress(0.0), commitTangent(0.0)
{

}

ElasticPPMaterial::~ElasticPPMaterial()
{
  // does nothing
}

int 
ElasticPPMaterial::setTrialStrain(double strain, double strainRate)
{
  /*
    if (fabs(trialStrain - strain) < DBL_EPSILON)
      return 0;
  */
    trialStrain = strain;

    double sigtrial;	// trial stress
    double f;		// yield function

    // compute trial stress
    sigtrial = E * ( trialStrain - ezero - ep );

    //sigtrial  = E * trialStrain;
    //sigtrial -= E * ezero;
    //sigtrial -= E *  ep;

    // evaluate yield function
    if ( sigtrial >= 0.0 )
	f =  sigtrial - fyp;
    else
	f = -sigtrial + fyn;

    double fYieldSurface = - E * DBL_EPSILON;
    if ( f <= fYieldSurface ) {

      // elastic
      trialStress = sigtrial;
      trialTangent = E;

    } else {

      // plastic
      if ( sigtrial > 0.0 ) {
	trialStress = fyp;
      } else {
	trialStress = fyn;
      }

      trialTangent = 0.0;
    }

    return 0;
}

double 
ElasticPPMaterial::getStrain(void)
{
  return trialStrain;
}

double 
ElasticPPMaterial::getStress(void)
{
  return trialStress;
}


double 
ElasticPPMaterial::getTangent(void)
{
  return trialTangent;
}

int 
ElasticPPMaterial::commitState(void)
{
    double sigtrial;	// trial stress
    double f;		// yield function

    // compute trial stress
    sigtrial = E * ( trialStrain - ezero - ep );

    // evaluate yield function
    if ( sigtrial >= 0.0 )
	f =  sigtrial - fyp;
    else
	f = -sigtrial + fyn;

    double fYieldSurface = - E * DBL_EPSILON;
    if ( f > fYieldSurface ) {
      // plastic
      if ( sigtrial > 0.0 ) {
	ep += f / E;
      } else {
	ep -= f / E;
      }
    }

    commitStrain = trialStrain;
    commitTangent=trialTangent;
    commitStress = trialStress;

    return 0;
}	


int 
ElasticPPMaterial::revertToLastCommit(void)
{
  trialStrain = commitStrain;
  trialTangent = commitTangent;
  trialStress = commitStress;

  return 0;
}


int 
ElasticPPMaterial::revertToStart(void)
{
  trialStrain = commitStrain = 0.0;
  trialTangent = commitTangent = E;
  trialStress = commitStress = 0.0;

  ep = 0.0;
  
  return 0;
}


UniaxialMaterial *
ElasticPPMaterial::getCopy(void)
{
  ElasticPPMaterial *theCopy =
    new ElasticPPMaterial(this->getTag(),E,fyp/E,fyn/E,ezero);
  theCopy->ep = this->ep;
  
  return theCopy;
}


int 
ElasticPPMaterial::sendSelf(int cTag, Channel &theChannel)
{
  int res = 0;
  static Vector data(9);
  data(0) = this->getTag();
  data(1) = ep;
  data(2) = E;
  data(3) = ezero;
  data(4) = fyp;
  data(5) = fyn;
  data(6) = commitStrain;
  data(7) = commitStress;
  data(8) = commitTangent;

  res = theChannel.sendVector(this->getDbTag(), cTag, data);
  if (res < 0) 
    opserr << "ElasticPPMaterial::sendSelf() - failed to send data\n";

  return res;
}

int 
ElasticPPMaterial::recvSelf(int cTag, Channel &theChannel, 
				 FEM_ObjectBroker &theBroker)
{
  int res = 0;
  static Vector data(9);
  res = theChannel.recvVector(this->getDbTag(), cTag, data);
  if (res < 0) 
    opserr << "ElasticPPMaterial::recvSelf() - failed to recv data\n";
  else {
    this->setTag(data(0));
    ep    = data(1);
    E     = data(2);
    ezero = data(3);
    fyp   = data(4);
    fyn   = data(5);  
    commitStrain=data(6);
    commitStress=data(7);
    commitTangent=data(8);
    trialStrain = commitStrain;
    trialTangent = commitTangent;
    trialStress = commitStress;
  }

  return res;
}

void 
ElasticPPMaterial::Print(OPS_Stream &s, int flag)
{
    s << "ElasticPP tag: " << this->getTag() << endln;
    s << "  E: " << E << endln;
    s << "  ep: " << ep << endln;
    s << "  Otress: " << trialStress << " tangent: " << trialTangent << endln;
}


