begin service 1
  code platomain
  number_processors 1
  number_ranks 1
end service

begin service 2
  code plato_analyze
  number_processors 1
  number_ranks 1
end service

begin criterion 1
  type mechanical_compliance
  minimum_ersatz_material_value 1e-9
end criterion

begin criterion 2
  type volume
end criterion

begin scenario 1
  physics steady_state_mechanics
  dimensions 3
  loads 1 2
  boundary_conditions 1
  material 1
  minimum_ersatz_material_value 1e-9
  linear_solver_tolerance 1e-12
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
    location_name ss_1
    value 0 -3e3 0
end load

begin load 2
    type traction
    location_type sideset
    location_name ss_2
    value 0 -3e3 0
end load
      
begin constraint 1
  criterion 2
  relative_target 0.3
  type less_than
  service 1
end constraint

begin block 1
   material aluminum
end block

begin block 2
   material steel
end block

begin material aluminum
   material_model isotropic_linear_elastic 
   poissons_ratio .33
   youngs_modulus 68e9
end material

begin material steel
   material_model isotropic_linear_elastic 
   poissons_ratio .27
   youngs_modulus 193e9
end material

begin optimization_parameters
   discretization density 
   initial_density_value .5
   optimization_algorithm rol_linear_constraint
   max_iterations 10 
   filter_radius_scale 1.75
   output_frequency 1000 
   normalize_in_aggregator false
end optimization_parameters

begin mesh
   name bb_2block.exo
end mesh

