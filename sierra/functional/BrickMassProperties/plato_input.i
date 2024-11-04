begin brick_shape_geometry
    mesh_name brick.exo
end

begin objective mass_properties
    app sierra_sd
    criterion mass-properties
    input_files salinas_input.i, targets.xml, weights.xml
    aggregation_weight 1.0
end

begin rol_optimization 
    max_iterations 5
    export_settings_file_name rol_options.xml
    approximate_hessian true
    initial_search_radius 1
end
