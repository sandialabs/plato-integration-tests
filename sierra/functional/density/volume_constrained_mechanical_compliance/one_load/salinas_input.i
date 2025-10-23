SOLUTION
  case '1'
  statics
END

GDSW
  solver_tol = 1e-4
END
OUTPUTS
END
ECHO
mass=block
END
MATERIAL 1
  isotropic
  E = 4.000000
  nu = .3
  density = 2.00000000
END

MATERIAL 2
  isotropic
  E = 8.000000
  nu = .3
  density = 2.00000000
END

BLOCK 1
  material 1
  Hex8f
END

BLOCK 2
  material 1
  Hex8f
END

BLOCK 3
  material 2
  Hex8f
END

BLOCK 4
  material 2
  Hex8f
END


LOADS
nodeset 2 
force .0 .01 .0
END
BOUNDARY
nodeset 1
fixed
END
