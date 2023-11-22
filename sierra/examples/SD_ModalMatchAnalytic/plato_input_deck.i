begin service 1  
  code platomain
  number_processors 1
end service

begin service 2
  code sierra_sd
  number_processors 8
  cache_state true
end service

begin service 3
  code plato_esp
  number_processors 3
end service

begin criterion 1
  type modal_projection_error
  num_modes_compute 12
  modes_to_exclude 7 8 9 10 11 12
  ref_data_file gold_brick-out.exo
  match_nodesets 1 2 3 4 5 6
end criterion

begin criterion 2
  type volume
end criterion

begin scenario 1
  physics modal_response
  dimensions 3
  boundary_conditions 1 2 3
  material 1
  tolerance 1e-8
  convert_to_tet10 true
end scenario

begin objective
  type weighted_sum
  criteria 1
  services 2
  shape_services 3
  scenarios 1
  weights 1
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
   poissons_ratio .31
   youngs_modulus 1.011e10
   mass_density 1.6e3
end material

begin optimization_parameters
   esp_workflow aflr4_aflr3
   max_iterations 22
   output_frequency 1
   optimization_algorithm rol_bound_constrained 
   rol_subproblem_model lin_more
   hessian_type zero
   normalize_in_aggregator false
   csm_file brick.csm
   num_shape_design_variables 3
   optimization_type shape
   verbose true
end optimization_parameters

begin mesh
   name brick.exo
end mesh

begin boundary_condition 1
    type fixed_value
    location_type sideset
    location_id 1
    degree_of_freedom dispx
    value 0
end boundary_condition

begin boundary_condition 2
    type fixed_value
    location_type sideset
    location_id 2
    degree_of_freedom dispy
    value 0
end boundary_condition

begin boundary_condition 3
    type fixed_value
    location_type sideset
    location_id 3
    degree_of_freedom dispz
    value 0
end boundary_condition
