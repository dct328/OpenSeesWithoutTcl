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
                                                                        
// $Revision: 1.14 $
// $Date: 2010-02-04 01:17:46 $
// $Source: /usr/local/cvs/OpenSees/SRC/element/zeroLength/ZeroLength.h,v $
                                                                        
                                                                        
#ifndef ZeroLength_h
#define ZeroLength_h

// File: ~/element/zeroLength/ZeroLength.h
// 
// Written: GLF
// Created: 12/99
// Revision: A
// Revised by Chenting on 180312
//
// Description: This file contains the class definition for ZeroLength.
// A ZeroLength element is defined by two nodes with the same coordinate.
// One or more material objects may be associated with the nodes to
// provide a force displacement relationship.
// ZeroLength element will work with 1d, 2d, or 3d material models.
//
// What: "@(#) ZeroLength.h, revA"

#include <Element.h>
#include <Matrix.h>
#include <ZeroLength.h>

// Tolerance for zero length of element
#define	LENTOL 1.0e-6

// Type of dimension of element NxDy has dimension x=1,2,3 and
// y=2,4,6,12 degrees-of-freedom for the element
enum Etype { D1N2, D2N4, D2N6, D3N6, D3N12 };


class Node;
class Channel;
class UniaxialMaterial;
class Response;
class ZeroLength;

class ZeroLengthConstructor
{
  public:

	ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, int direction1, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping = 0);
	ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, int direction1, int direction2, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping=0);
	ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, int direction1, int direction2, int direction3, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping=0);
	ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, UniaxialMaterial& theMaterial4, int direction1, int direction2, int direction3, int direction4, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping=0);
	ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, UniaxialMaterial& theMaterial4, UniaxialMaterial& theMaterial5, int direction1, int direction2, int direction3, int direction4, int direction5, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping=0);
	ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, UniaxialMaterial& theMaterial4, UniaxialMaterial& theMaterial5, UniaxialMaterial& theMaterial6, int direction1, int direction2, int direction3, int direction4, int direction5, int direction6, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping=0);
	ZeroLength ConstructElement(void);

  protected:
    
  private:
	ZeroLength *theEle;
};

#endif




