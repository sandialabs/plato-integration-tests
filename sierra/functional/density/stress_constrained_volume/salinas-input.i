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
END

MATERIAL 1
  isotropic
  E = 4.0
  nu = 0.3
  density = 2.0
END

MATERIAL 2
  isotropic
  E = 8.0
  nu = 0.3
  density = 2.0
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
force 0.0 1e-4 0.0
END

BOUNDARY
nodeset 1
fixed
END
