begin level_set_topology
    mesh_name unit_cube_background.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_list radius 0.25 center (0.5,0.5,0.5)
    level_set_bounds [-0.2, 0.2]
end

begin identity_filter
end

begin objective compliance
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1 
end

begin objective mass
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mass.xml
    aggregation_weight 1 
end

begin rol_optimization
    input_file_name rol_inputs_BC.xml
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end
