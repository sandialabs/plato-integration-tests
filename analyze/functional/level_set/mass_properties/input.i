begin level_set_topology
    mesh_name lbracket-two-block.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_list radius 0.25 center (0,0,0)
    level_set_bounds [-1, 1]
    fixed_blocks block_1
end

begin kernel_filter
    filter_radius 2
    centering_type node
    use_relative_radius true
end

begin objective mass_properties
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mass_properties.xml
    aggregation_weight 1000
end

begin rol_optimization
    max_iterations 3
    approximate_hessian true
    initial_search_radius 20
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end
