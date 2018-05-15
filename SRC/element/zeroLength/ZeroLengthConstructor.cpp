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
                                                                        
// $Revision: 1.27 $
// $Date: 2010-02-04 01:17:46 $
// Revised by Chenting on 180312
// $Source: /usr/local/cvs/OpenSees/SRC/element/zeroLength/ZeroLength.cpp,v $

// Written: GLF
// Created: 12/99
// Revision: A
//
// Description: This file contains the implementation for the ZeroLength class.
//
// What: "@(#) ZeroLength.C, revA"
#include <ZeroLengthConstructor.h>
#include <ZeroLength.h>
#include <Information.h>

#include <Domain.h>
#include <Node.h>
#include <Channel.h>
#include <FEM_ObjectBroker.h>
#include <UniaxialMaterial.h>
#include <Renderer.h>

#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <ElementResponse.h>
#include <elementAPI.h>
#include <vector>


ZeroLengthConstructor::ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, int direction1, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping)
{
    UniaxialMaterial *theMats[1];
    theMats[0] = &theMaterial1;
    Vector x(3);
    x(0) = x1;
    x(1) = x2;
    x(2) = x3;
    Vector y(3);
    y(0) = yp1;
    y(1) = yp2;
    y(2) = yp3;
    ID dirs(1);
    dirs(0) = direction1;
    ZeroLength *theEle = new ZeroLength(tag, dimension, Nd1, Nd2, x, y, 1, theMats, dirs, doRayleighDamping);

}

ZeroLengthConstructor::ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, int direction1, int direction2, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping)
{
    UniaxialMaterial *theMats[2];
    theMats[0] = &theMaterial1;
    theMats[1] = &theMaterial2;
    Vector x(3);
    x(0) = x1;
    x(1) = x2;
    x(2) = x3;
    Vector y(3);
    y(0) = yp1;
    y(1) = yp2;
    y(2) = yp3;
    ID dirs(2);
    dirs(0) = direction1;
    dirs(1) = direction2;
    ZeroLength *theEle = new ZeroLength(tag, dimension, Nd1, Nd2, x, y, 2, theMats, dirs, doRayleighDamping);

}

ZeroLengthConstructor::ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, int direction1, int direction2, int direction3, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping)
{
    UniaxialMaterial *theMats[3];
    theMats[0] = &theMaterial1;
    theMats[1] = &theMaterial2;
    theMats[2] = &theMaterial3;
    Vector x(3);
    x(0) = x1;
    x(1) = x2;
    x(2) = x3;
    Vector y(3);
    y(0) = yp1;
    y(1) = yp2;
    y(2) = yp3;
    ID dirs(3);
    dirs(0) = direction1;
    dirs(1) = direction2;
    dirs(2) = direction3;
    ZeroLength *theEle = new ZeroLength(tag, dimension, Nd1, Nd2, x, y, 3, theMats, dirs, doRayleighDamping);

}

ZeroLengthConstructor::ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, UniaxialMaterial& theMaterial4, int direction1, int direction2, int direction3, int direction4, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping)
{
    UniaxialMaterial *theMats[4];
    theMats[0] = &theMaterial1;
    theMats[1] = &theMaterial2;
    theMats[2] = &theMaterial3;
    theMats[3] = &theMaterial4;
    Vector x(3);
    x(0) = x1;
    x(1) = x2;
    x(2) = x3;
    Vector y(3);
    y(0) = yp1;
    y(1) = yp2;
    y(2) = yp3;
    ID dirs(4);
    dirs(0) = direction1;
    dirs(1) = direction2;
    dirs(2) = direction3;
    dirs(3) = direction4;
    ZeroLength *theEle = new ZeroLength(tag, dimension, Nd1, Nd2, x, y, 4, theMats, dirs, doRayleighDamping);

}

ZeroLengthConstructor::ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, UniaxialMaterial& theMaterial4, UniaxialMaterial& theMaterial5, int direction1, int direction2, int direction3, int direction4, int direction5, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping)
{
    UniaxialMaterial *theMats[5];
    theMats[0] = &theMaterial1;
    theMats[1] = &theMaterial2;
    theMats[2] = &theMaterial3;
    theMats[3] = &theMaterial4;
    theMats[4] = &theMaterial5;
    Vector x(3);
    x(0) = x1;
    x(1) = x2;
    x(2) = x3;
    Vector y(3);
    y(0) = yp1;
    y(1) = yp2;
    y(2) = yp3;
    ID dirs(5);
    dirs(0) = direction1;
    dirs(1) = direction2;
    dirs(2) = direction3;
    dirs(3) = direction4;
    dirs(4) = direction5;
    ZeroLength *theEle = new ZeroLength(tag, dimension, Nd1, Nd2, x, y, 5, theMats, dirs, doRayleighDamping);

}

ZeroLengthConstructor::ZeroLengthConstructor(int tag, int dimension, int Nd1, int Nd2, UniaxialMaterial& theMaterial1, UniaxialMaterial& theMaterial2, UniaxialMaterial& theMaterial3, UniaxialMaterial& theMaterial4, UniaxialMaterial& theMaterial5, UniaxialMaterial& theMaterial6, int direction1, int direction2, int direction3, int direction4, int direction5, int direction6, double x1, double x2, double x3, double yp1, double yp2, double yp3, int doRayleighDamping)
{
    UniaxialMaterial *theMats[6];
    theMats[0] = &theMaterial1;
    theMats[1] = &theMaterial2;
    theMats[2] = &theMaterial3;
    theMats[3] = &theMaterial4;
    theMats[4] = &theMaterial5;
    theMats[5] = &theMaterial6;
    Vector x(3);
    x(0) = x1;
    x(1) = x2;
    x(2) = x3;
    Vector y(3);
    y(0) = yp1;
    y(1) = yp2;
    y(2) = yp3;
    ID dirs(5);
    dirs(0) = direction1;
    dirs(1) = direction2;
    dirs(2) = direction3;
    dirs(3) = direction4;
    dirs(4) = direction5;
    dirs(5) = direction6;
    ZeroLength *theEle = new ZeroLength(tag, dimension, Nd1, Nd2, x, y, 1, theMats, dirs, doRayleighDamping);

}

ZeroLength ZeroLengthConstructor::ConstructElement(void)
{
    return *theEle;
}