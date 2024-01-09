begin service 1  
  code platomain
  number_processors 1
end service

begin service 2
  code plato_analyze
  number_processors 1
end service

begin service 3
  code plato_esp
  number_processors 1
end service

begin criterion 1
  type mass_properties
  mass 22.665638 weight 1
end criterion

begin scenario 1
  physics steady_state_mechanics
  dimensions 3
  material 1
  loads 1
  boundary_conditions 1
  linear_solver_tolerance 1e-6
end scenario

begin boundary_condition 1
   type fixed_value
   location_type sideset
   location_name bc_face
   degree_of_freedom dispx dispz
   value 0 0
end boundary_condition

begin load 1
   type traction
   location_type sideset
   location_name load_face
   value 0 0 0
end load


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
end block

begin block 2
   material 1
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .33
   youngs_modulus 1e9
   mass_density .2
end material

begin optimization_parameters
   max_iterations 15
   output_frequency 1000
   optimization_algorithm rol_bound_constrained
   rol_subproblem_model lin_more
   normalize_in_aggregator false
   csm_file sphere_block.csm
   num_shape_design_variables 1
   optimization_type shape
end optimization_parameters

begin mesh
   name sphere_block.exo
end mesh

