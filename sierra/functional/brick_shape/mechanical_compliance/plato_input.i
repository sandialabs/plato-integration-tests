begin brick_shape_geometry
    mesh_name brick.exo
end

begin objective compliance
    app sierra_sd
    criterion compliance
    input_files salinas_input.i
    aggregation_weight 1.0
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.5
    random_direction_seed 1
end

begin rol_optimization 
    max_iterations 5
    export_settings_file_name rol_options.xml
    approximate_hessian true
    initial_search_radius 1
end
