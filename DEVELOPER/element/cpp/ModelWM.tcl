model BasicBuilder -ndm 3 -ndf 6
geomTransf Linear 1 1 0 0
geomTransf Linear 2 0 1 0
geomTransf Linear 3 0 0 1
geomTransf Linear 4 1 1 0
geomTransf PDelta 5 0 1 0

set pi 3.1415926
set dhole 22.0
set dbolt 20.0
set nbolt 1.0
set EBolt 206000.0
set PossionsRatio 0.3

set EPlate 205000.0
set FyPlate 270.0
set FrictionCoeff 0.3
set dcoreplate 24.0
set dcoverplate 12.0
set PlateWidth 120.0

set PreLoad 155000.0

set ABolt [expr $pi*$dbolt*$dbolt/4*$nbolt]
set ABoltShear [expr $ABolt*0.9]
set IBolt [expr $pi*pow($dbolt*0.5,4)/4*$nbolt]
set JBolt [expr $IBolt*10]
set GBolt [expr $EBolt/(2*($PossionsRatio+1))]

set l1 110.0
set l3 60.0

# ========================================= uniaxial materials ===================================

## Rigid Material
uniaxialMaterial Elastic 102 2.1e9

## Flexible Material
uniaxialMaterial Elastic 103 2.1e-6

## Pretension Material
uniaxialMaterial Steel02 22 995000000 1 0.012 15 0.925 0.15 0 1 0 1 [expr $PreLoad/($ABolt/$nbolt)]

# End Plate Material
uniaxialMaterial Steel01 203 $FyPlate $EPlate 0.02

uniaxialMaterial ElasticMultiLinear 1 -strain -5 [expr $dbolt-$dhole] 0 [expr -$dbolt+$dhole] 5 -stress -729088.4 -0.1 0 0.1 729088.4

# =========================================== Sections ========================================

# section of core plate with normal width
section Fiber 11 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$PlateWidth/2] [expr $dcoreplate/2] [expr $PlateWidth/2]
}

# section of core plate with width 108.02
set tempw 108.02
section Fiber 12 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of core plate with width 65.68
set tempw 65.68
section Fiber 13 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of core plate with width 152.948
set tempw 23.34
section Fiber 14 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of cover plate with normal width
section Fiber 21 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$PlateWidth/2] [expr $dcoverplate/2] [expr $PlateWidth/2]
}

# section of cover plate with width 253.54
set tempw 115.72
section Fiber 22 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 202.352
set tempw 92.62
section Fiber 23 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 151.162
set tempw 69.5295
section Fiber 24 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 151.162
set tempw 46.435
section Fiber 25 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 99.973
set tempw 23.34
section Fiber 26 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# Friction
frictionModel Coulomb 2 $FrictionCoeff

# ====================================== Nodes ==============================================
# Nodes of core plate
node 1 [expr -$l1-$l3] 0 0
node 2 [expr -$l3] 0 0
#node 102 [expr -$l3] 0 0
node 5 [expr $l3] 0 0
#node 105 [expr $l3] 0 0
node 6 [expr $l1+$l3] 0 0

# Nodes of upper cover plate
node 7 [expr -$l3] 0 [expr $dcoreplate/2+$dcoverplate/2]
node 10 [expr $l3] 0 [expr $dcoreplate/2+$dcoverplate/2]
node 15 0 0 [expr $dcoreplate/2+$dcoverplate/2]

# Nodes of lower cover plate
node 11 [expr -$l3] 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 14 [expr $l3] 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 16 0 0 [expr -$dcoreplate/2-$dcoverplate/2]

fix 1 1 1 1 1 1 1
fix 6 0 1 1 1 1 1
puts "fee"
# ====================================== Elements ==============================================
# ========== Elements of Core Plate ==

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "11 11 11 11 11 11 11 12 13 14"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 1 1 2 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "14 13 12 11 11 11 11 11 11 11"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 2 5 6 2 $integration

# ========== Elements of upper Cover Plate ==
set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "26 25 24 23 22 21 21 21 21 21"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 3 7 15 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "21 21 21 21 21 22 23 24 25 26"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 4 15 10 2 $integration

# ========== Elements of lower Cover Plate ==
set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "26 25 24 23 22 21 21 21 21 21"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 5 11 16 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "21 21 21 21 21 22 23 24 25 26"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 6 16 14 2 $integration

# ========== Elements of Frictional Bearings ==
set ShearRatio [expr $dcoreplate/($dcoreplate+$dcoverplate)]
element flatSliderBearing 201 2 7 2 170000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist $ShearRatio -iter 500 1e-12
element flatSliderBearing 202 2 11 2 170000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist $ShearRatio -iter 500 1e-12

element flatSliderBearing 207 5 10 2 170000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist $ShearRatio -iter 500 1e-12
element flatSliderBearing 208 5 14 2 170000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist $ShearRatio -iter 500 1e-12

# ========== Elements of Bolt Shank ==
#set lenf [expr ($dcoreplate + $dcoverplate*2)/($dcoreplate + $dcoverplate)]
#element ElasticTimoshenkoBeam 301 102 7 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
#element ElasticTimoshenkoBeam 302 102 11 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf

#element ElasticTimoshenkoBeam 307 105 10 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
#element ElasticTimoshenkoBeam 308 105 14 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf

# ========== Elements of Applying Pretension ==
element truss 401 11 7 $ABolt 22
element truss 404 14 10 $ABolt 22

# ========== Elements of Local Bearing ==
#element zeroLength 501 2 102 -mat 1 -dir 1 -orient 1 0 0 0 1 0
#element zeroLength 504 5 105 -mat 1 -dir 1 -orient 1 0 0 0 1 0

timeSeries Trig 8 0 250 1000 -factor 6

pattern MultipleSupport 9 {
groundMotion 9 Plain -disp 8 -fact 1
imposedMotion 6 1 9
}

recorder Node -file WMNodeDisp6.out -time -dT 0.5 -node 6 15 16 -dof 1 2 3 4 5 6 disp
recorder Node -file WMNodeDisp123456.out -time -dT 0.5 -node 1 2 5 6 7 10 11 14 -dof 1 disp
recorder Element -file WMElements.out -time -dT 0.5 -ele 1 4 globalForce
recorder Element -file WMBearingsForce.out -time -dT 0.5 -ele 201 202 207 208 localForce
recorder Element -file WMBearingsLD.out -time -dT 0.5 -ele 201 202 207 208 localDisplacement
recorder Element -file WMBearingsBD.out -time -dT 0.5 -ele 201 202 207 208 basicDisplacement

constraints Transformation
numberer  RCM
system UmfPack
test EnergyIncr 1e-7 300 0 2
algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
#algorithm KrylovNewton
integrator TRBDF2
#integrator Newmark 0.5 0.25
analysis Transient

#parameter 1 element 401 material sigini
#parameter 2 element 402 material sigini

set ok 0;
#set Nsteps 10000;
set Nsteps 25000;
set step 1;

while {$ok == 0 & $step < [expr $Nsteps +1]} {
  test EnergyIncr 1e-7 300 1 2
  set ok [analyze 1 0.01]
  if {$ok == 0} {
    #set ps [expr 493380323.6*(pow(2,-$step*1.0/$Nsteps))]
    #puts $ps
    #updateParameter 1 $ps
    #updateParameter 2 $ps
    puts "Running Time History Step: $step out of $Nsteps"
    set step [expr $step+1]
  } else {
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.005 and BFGS"
      test EnergyIncr 1e-7 300 1 2
      algorithm Broyden -count 30
      set ok [analyze 1 0.01]
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
  }
}
