/* ****************************************************************** **
**    OpenSees - Open System for Earthquake Engineering Simulation    **
**          Pacific Earthquake Engineering Research Center            **
**                                                                    **
**                                                                    **
** (C) Copyright 2001, The Regents of the University of California    **
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
** Reliability module developed by:                                   **
**   Terje Haukaas (haukaas@ce.berkeley.edu)                          **
**   Armen Der Kiureghian (adk@ce.berkeley.edu)                       **
**                                                                    **
** ****************************************************************** */
                                                                        
// $Revision: 1.1 $
// $Date: 2003-03-04 00:44:51 $
// $Source: /usr/local/cvs/OpenSees/SRC/reliability/domain/spectrum/NarrowBandSpectrum.cpp,v $


//
// Written by Terje Haukaas (haukaas@ce.berkeley.edu)
//

#include <NarrowBandSpectrum.h>
#include <Spectrum.h>
#include <Vector.h>
#include <classTags.h>


NarrowBandSpectrum::NarrowBandSpectrum(int tag, double min, double max, double ampl)
:Spectrum(tag,SPECTRUM_constant)
{
	minFreq = min;
	maxFreq = max;
	amplitude = ampl;
}

NarrowBandSpectrum::~NarrowBandSpectrum()
{
}

void
NarrowBandSpectrum::Print(OPS_Stream &s, int flag)  
{
}


double
NarrowBandSpectrum::getMinFrequency()
{
	return minFreq;
}


double
NarrowBandSpectrum::getMaxFrequency()
{
	return maxFreq;
}


double
NarrowBandSpectrum::getAmplitude(double frequency)
{
	if (frequency < minFreq || frequency > maxFreq) {
		return 0.0;
	}
	else {
		return amplitude;
	}
}
