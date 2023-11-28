SOLUTION
  eigen
  nmodes 12
  solver gdsw
END
OUTPUTS
  disp
END
ECHO
END
MATERIAL 1
  isotropic
  E = 1.011e10
  nu = 0.31
  density = 1.6e3
END
BLOCK 1
  material 1
  cutet10
END
FILE
  geometry_file 'gold_brick.exo'
END
LOADS
END
BOUNDARY
  sideset x_constraint
    x=0
  sideset y_constraint
    y=0
  sideset z_constraint
    z=0
END
