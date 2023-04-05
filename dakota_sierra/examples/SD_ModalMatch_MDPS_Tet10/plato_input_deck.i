begin service 1  
  code platomain
  number_processors 1
end service

begin service 2
  code sierra_sd
  number_processors 1
  cache_state true
end service

begin criterion 1
  type modal_projection_error
  num_modes_compute 30
  modes_to_exclude 1 2 3 4 5 6 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
  eigen_solver_shift -5e8
  camp_solver_tol 1e-4
  camp_max_iter 5000
  shape_sideset 3
  ref_data_file gold_brick-out.exo
  match_nodesets 4 5 6 7 8 9
end criterion

begin scenario 1
  physics modal_response
  dimensions 3
  material 1
  tolerance 1e-8
  convert_to_tet10 true
end scenario

begin objective
  type single_criterion
  criteria 1
  services 2
  scenarios 1
end objective

begin output
   service 2
   output_data true
   data dispx dispy dispz
end output

begin block 1
   material 1
   element_type tet10
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .42
   youngs_modulus 2.274e9
   mass_density 2.59e-4
end material

begin optimization_parameters
   optimization_type dakota
   esp_workflow egads_tetgen
   dakota_workflow mdps
   mdps_partitions 20
   mdps_response_functions 1
   concurrent_evaluations 3
   num_shape_design_variables 1
   csm_file whole_brick.csm
   verbose true
end optimization_parameters

begin mesh
   name whole_brick.exo
end mesh
