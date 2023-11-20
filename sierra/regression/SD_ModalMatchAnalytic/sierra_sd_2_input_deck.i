SOLUTION
  case '1'
  topology_optimization
  nmodes 30
  modalAdjointSolver = camp
  shift -1e6
  solver gdsw
END
PARAMETERS
  swapModes no
END
CAMP
  solver_tol 1e-6
  preconditioner gdsw
  max_iter 1000
END
INVERSE-PROBLEM
  data_truth_table dummy_eigen_ttable_1.txt
  data_file dummy_eigen_data_1.txt
  modal_data_file dummy_modal_data_1.txt
  modal_weight_table dummy_modal_weight_1.txt
  shape_bounds 1.0
  eigen_objective mpe
  design_variable shape
END
OPTIMIZATION
  optimization_package ROL_lib
  ROLmethod linesearch
  LSstep Newton-Krylov
  LS_curvature_condition null
  Max_iter_Krylov 50
  Use_FD_hessvec false
  Use_inexact_hessvec false
END
GDSW
  solver_tol = 1e-8
  SC_option 0
END
OUTPUTS
END
ECHO
END
MATERIAL 1
  isotropic
  E = 1.011e10
  nu = .31
  density = 1.6e3
END
BLOCK 1
  material 1
END
TOPOLOGY-OPTIMIZATION
  algorithm = plato_engine
  case = inverse_methods
  inverse_method_objective = eigen-inverse
  ref_data_file gold_brick-out.exo
  match_nodesets 4 5 6 7 8 9
  modes_to_exclude 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
  volume_fraction = .314
  objective_normalization false
END
FILE
  geometry_file 'brick.exo'
END
LOADS
END
BOUNDARY
  nodeset x_constraint
    x=0
  nodeset y_constraint
    y=0
  nodeset z_constraint
    z=0
END
