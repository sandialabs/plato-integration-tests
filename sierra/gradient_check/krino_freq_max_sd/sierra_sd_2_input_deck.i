SOLUTION
  case '1'
  topology_optimization
  nmodes 4
//  modalAdjointSolver = camp
  shift -1
  solver gdsw
END
//PARAMETERS
//  swapModes no
//END
//CAMP
//  solver_tol 1e-4
//  preconditioner gdsw
//  max_iter 5000
//END
INVERSE-PROBLEM
//  data_truth_table dummy_eigen_ttable_1.txt
//  data_file dummy_eigen_data_1.txt
//  modal_data_file dummy_modal_data_1.txt
//  modal_weight_table dummy_modal_weight_1.txt
  shape_bounds 0.1 
  eigen_objective max
  design_variable shape
  shape_sideset = 15
END
OPTIMIZATION
//  optimization_package ROL_lib
//  ROLmethod linesearch
//  LSstep Newton-Krylov
//  LS_curvature_condition null
//  Max_iter_Krylov 50
//  Use_FD_hessvec false
//  Use_inexact_hessvec false
END
GDSW
  solver_tol = 1e-8
//  SC_option 0
END
OUTPUTS
disp
END
ECHO
END
MATERIAL 1
// Ti64 in CGS units
  isotropic
  // dyne/cm^2
  E = 1.138e9
  nu = .342
  // g/cm^3
  density = 4.43
END
MATERIAL 2
// Soft material in CGS units
  isotropic
  // dyne/cm^2
  E = 1.138e5
  nu = .342
  // g/cm^3
  density = 4.43
END
BLOCK 1
  material 1
END
BLOCK 2
  material 1
END
BLOCK 10
  material 2
END
TOPOLOGY-OPTIMIZATION
  algorithm = plato_engine
  case = inverse_methods
  inverse_method_objective = eigen-inverse
  ref_data_file data_to_match.exo
  match_nodesets 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20 21 22 23
  modes_to_exclude 1 2 3 4 5 6 10 11 12 13 14 15 16 17 18 19 20
  volume_fraction = .314
  objective_normalization false
  objective_model = lsto_with_krino
END
FILE
  geometry_file 'bg.exo'
END
LOADS
END
BOUNDARY
sideset 1 fixed
END
