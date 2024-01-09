begin service 1
  code platomain
  number_processors 1
  number_ranks 1
  update_problem true
end service

begin service 2
  code plato_analyze
  number_processors 1
  number_ranks 1
end service

begin criterion 1
  type mechanical_compliance
  minimum_ersatz_material_value 1e-3
end criterion

begin criterion 2
  type volume
end criterion

begin scenario 1
  physics steady_state_mechanics
  dimensions 3
  loads 1
  boundary_conditions 1
  material 1
  minimum_ersatz_material_value 1e-3
  linear_solver_tolerance 1e-12
end scenario

begin objective
  type weighted_sum
  criteria 1
  services 2
  scenarios 1
  weights 1
end objective

begin output
    service 2
   output_data true
   data dispx dispy dispz
end output

begin boundary_condition 1
    type fixed_value
    location_type nodeset
    location_name ns_1
    degree_of_freedom dispx dispz dispy
    value 0 0 0
end boundary_condition

begin load 1
    type traction
    location_type sideset
    location_name ss_2
    value 0 -3e3 0
end load
      
begin constraint 1
  criterion 2
  relative_target 0.25
  type less_than
  service 1
end constraint

begin block 1
   material 1
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .3
   youngs_modulus 1e8
end material

begin optimization_parameters
   filter_type helmholtz
   filter_radius_absolute 0.693
   boundary_sticking_penalty -1.0
   max_iterations 20 
   projection_type tanh
   filter_projection_start_iteration 10
   filter_projection_update_interval 5
   filter_use_additive_continuation true
   filter_heaviside_min 1
   filter_heaviside_max 25
   filter_heaviside_update 2
   problem_update_frequency 1
   output_frequency 1000 
   optimization_algorithm rol_linear_constraint
   discretization density 
   initial_density_value .25
   normalize_in_aggregator false
end optimization_parameters

begin mesh
   name bolted_bracket_1.exo
end mesh

