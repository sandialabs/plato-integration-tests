begin level_set_topology
    mesh_name cylinder.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_list radius 1 center(5,0,0)
    level_set_bounds [-1, 1]
    fixed_blocks fixed_block
    max_edge_length_percentage_for_snapping 0
end

begin kernel_filter
    filter_radius 1
    use_relative_radius true
    centering_type node
end

begin objective thermal_compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_thermal_compliance.xml
    aggregation_weight 1e-8 
    
end

begin objective volume_obj
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    aggregation_weight 1 
end

begin rol_optimization
    max_iterations 3
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end
