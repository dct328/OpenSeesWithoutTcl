model BasicBuilder -ndm 3 -ndf 6
geomTransf Linear 1 1 0 0
geomTransf Linear 2 0 1 0
geomTransf Linear 3 0 0 1
geomTransf Linear 4 1 1 0
geomTransf PDelta 5 0 1 0

# ========================================= Parameters ===================================
set pi 3.141592654
set dhole 0.0175
set dbolt 0.016
set nbolt 4
set EBolt 206000000000.0
set PossionsRatio 0.3

set EPlate 205e9
set FyPlate 370e6
set FrictionCoeff 0.212
set dcoreplate 0.016
set dcoverplate 0.012
set PlateWidth 0.2

set PreLoad 110000.0

set ABolt [expr $pi*$dbolt*$dbolt/4*$nbolt]
set ABoltShear [expr $ABolt*0.9]
set IBolt [expr $pi*pow($dbolt*0.5,4)/4*$nbolt]
set JBolt [expr $IBolt*10]
set GBolt [expr $EBolt/(2*($PossionsRatio+1))]

# ========================================= nDmaterials ===================================

# ========================================= uniaxial materials ===================================
uniaxialMaterial Elastic 102 2.1e13
#uniaxialMaterial ENT 101 2.1E+14
uniaxialMaterial Steel02 22 995000000 1 0.012 15 0.925 0.15 0 1 0 1 [expr $PreLoad/($ABolt/$nbolt)]
#uniaxialMaterial Elastic 23 44803944.46

# Steel EndPlate
uniaxialMaterial Steel01 203 $FyPlate $EPlate 0.02

# =========================================== Sections ========================================

# section of core plate
section Fiber 24 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$PlateWidth/2] [expr $dcoreplate/2] [expr $PlateWidth/2]
}

# section of 3 plates 
section Fiber 124 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate-$dcoreplate/2] [expr -$PlateWidth/2] [expr $dcoverplate+$dcoreplate/2] [expr $PlateWidth/2]
}

section Fiber 25 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$PlateWidth/2] [expr $dcoverplate/2] [expr $PlateWidth/2]
}



# Friction
frictionModel Coulomb 2 $FrictionCoeff

node 1 -0.0825 0 0
node 2 -0.0825 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 3 -0.0825 0 [expr $dcoreplate/2+$dcoverplate/2]

node 4 0.0825 0 0
node 5 0.0825 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 6 0.0825 0 [expr $dcoreplate/2+$dcoverplate/2]

node 7 -0.265 0 0
node 8 0.265 0 0
#node 9 -0.165 0 0
#node 10 0.165 0 0

node 101 -0.0825 0 0
#node 102 -0.0825 0 [expr -$dcoreplate/2-$dcoverplate/2]
#node 103 -0.0825 0 [expr $dcoreplate/2+$dcoverplate/2]

node 104 0.0825 0 0
#node 105 0.0825 0 [expr -$dcoreplate/2-$dcoverplate/2]
#node 106 0.0825 0 [expr $dcoreplate/2+$dcoverplate/2]

mass 1 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12 
mass 2 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12
mass 3 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12
mass 4 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12
mass 5 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12
mass 6 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12
mass 7 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12
mass 8 1e-12 1e-12 1e-12 1e-12 1e-12 1e-12

fix 7 1 1 1 1 1 1
fix 8 0 1 1 1 1 1

equalDOF 1 101 2 3 4 6
equalDOF 4 104 2 3 4 6
#equalDOF 2 102 1 2 3 4 6
#equalDOF 3 103 1 2 3 4 6
#equalDOF 6 106 1 2 3 4 6
#equalDOF 5 105 1 2 3 4 6

# ========== The Column ============================================================
element forceBeamColumn 1 1 7 10 24 5
#element forceBeamColumn 901 9 7 7 24 5
element forceBeamColumn 2 4 8 10 24 5
#element forceBeamColumn 902 10 8 7 24 5
element forceBeamColumn 3 2 5 7 25 5
element forceBeamColumn 4 3 6 7 25 5

uniaxialMaterial ElasticMultiLinear 1 -strain -0.005 [expr $dbolt-$dhole] 0 [expr -$dbolt+$dhole] 0.005 -stress -2056489.74958 -0.1 0 0.1 2056489.74958
#uniaxialMaterial ElasticMultiLinear 1 -strain -0.005 [expr $dbolt-$dhole] 0 [expr -$dbolt+$dhole] 0.005 -stress -1794759.2727 -0.1 0 0.1 1794759.2727

puts "ProblemType"

set lenf [expr ($dcoreplate + $dcoverplate*2)/($dcoreplate + $dcoverplate)]
element ElasticTimoshenkoBeam 302 101 2 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 303 101 3 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 304 104 5 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 305 104 6 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf

#-lenfactor 1.333333333
element truss 401 2 3 $ABolt 22
element truss 402 5 6 $ABolt 22

element zeroLength 101 1 101 -mat 1 -dir 1 -orient 1 0 0 0 1 0
element zeroLength 102 4 104 -mat 1 -dir 1 -orient 1 0 0 0 1 0

#element singleFPBearing $eleTag $iNode $jNode $frnMdlTag $Reff $kInit -P $matTag -T $matTag -My $matTag -Mz $matTag
element singleFPBearing 202 1 2 2 0.3 33860000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist 0.625 -iter 500 1e-11
element singleFPBearing 203 1 3 2 0.3 33860000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist 0.625 -iter 500 1e-11

element singleFPBearing 204 4 5 2 0.3 33860000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist 0.625 -iter 500 1e-11
element singleFPBearing 205 4 6 2 0.3 33860000000 -P 102 -T 102 -My 102 -Mz 102 -shearDist 0.625 -iter 500 1e-11

#timeSeries Path 8 -dt 0.01 -filePath /home/chenting/Chenting/bin/SimplifiedModel/Motion.txt
timeSeries Trig 8 0 12000 1000 -factor 0.006

pattern MultipleSupport 9 {
groundMotion 9 Plain -disp 8 -fact 1
imposedMotion 8 1 9
}

recorder Node -file T5NodeDisp8.out -time -dT 0.5 -node 8 -dof 1 2 3 4 5 6 disp
recorder Node -file T5NodeDisp104.out -time -dT 0.5 -node 104 -dof 1 2 3 4 5 6 disp
recorder Node -file T5NodeDisp.out -time -dT 0.5 -node 1 2 3 4 5 6 -dof 1 2 3 4 5 6 disp
recorder Element -file T5Elements.out -time -dT 0.5 -ele 1 2 globalForce
recorder Element -file T5Element202203.out -time -dT 0.5 -ele 202 203 localForce
recorder Element -file T5Element202203d.out -time -dT 0.5 -ele 202 203 localDisplacement
recorder Element -file T5Zerolength.out -time -dT 0.5 -ele 101 104 force
#recorder Element -file T5Zerolengthd.out -time -dT 0.5 -ele 101 104 deformation
recorder Element -file T5Element302303.out -time -dT 0.5 -ele 302 303 force

constraints Transformation
numberer  RCM
system UmfPack
test EnergyIncr 1e-11 300 0 2
algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
#algorithm BFGS -count 100
#integrator TRBDF2
integrator Newmark 0.5 0.25
analysis Transient

parameter 1 element 401 material sigini
parameter 2 element 402 material sigini

set ok 0;
set Nsteps 25000;
set step 1;

while {$ok == 0 & $step < [expr $Nsteps +1]} {
  test EnergyIncr 1e-11 300 1 2
  set ok [analyze 1 0.01]
  if {$ok == 0} {
    set ps [expr 493380323.6*(pow(2,-$step*1.0/$Nsteps))]
    puts $ps
    updateParameter 1 $ps
    updateParameter 2 $ps
    puts "Running Time History Step: $step out of $Nsteps"
    set step [expr $step+1]
  } else {
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.005 and BFGS"
      test EnergyIncr 1e-11 300 1 2
      algorithm BFGS -count 100
      set ok [analyze 1 0.01]
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.005 and BFGS"
      test EnergyIncr 1e-11 300 1 2
      set ok [analyze 2 0.005]
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0025 and BFGS"
      test EnergyIncr 1e-11 300 1 2
      set ok [analyze 4 0.0025]
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.01 and Lower Tol 1e-9"
      test EnergyIncr 1e-11 300 0 2
      algorithm Broyden -count 50
      set ok [analyze 1 0.01]
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.001 and KrylovNewton "
      algorithm KrylovNewton
      set ok [analyze 10 0.001]
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and KrylovNewton"
      algorithm NewtonLineSearch
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 10} {
        set ok [analyze 1 0.001 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 9} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 8} {
          set ok [analyze 1 0.003]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 7} {
          set ok [analyze 1 0.004]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0 && $iter < 9} {
          set ok [analyze 2 0.0005]
          if {$ok == 0} {
            set iter [expr $iter + 1]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and BFGS and Tol 1e-8 "
      algorithm BFGS -count 100
      test EnergyIncr 1e-10 300 0 2
      set ok [analyze 20 0.0005 ]
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and NewtonLineSearch(Secant) "
      #algorithm KrylovNewton -maxDim 2
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 20} {
        set ok [analyze 1 0.0005 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 19} {
          set ok [analyze 1 0.001]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 18} {
          set ok [analyze 1 0.0015]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 17} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and NewtonLineSearch(interpo)"
      #algorithm KrylovNewton -maxDim 2
      algorithm NewtonLineSearch -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 20} {
        set ok [analyze 1 0.0005 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 19} {
          set ok [analyze 1 0.001]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 18} {
          set ok [analyze 1 0.0015]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 17} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and KrylovNewton"
      algorithm NewtonLineSearch
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 20} {
        set ok [analyze 1 0.0005 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 19} {
          set ok [analyze 1 0.001]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 18} {
          set ok [analyze 1 0.0015]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 17} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
  }
}

