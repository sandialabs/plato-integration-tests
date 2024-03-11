begin brick_shape_geometry
    mesh_name brick.exo
end

begin objective mass_properties
    active true
    app custom_app
    shared_library_path libplato_sd_mass_lib.so
    input_files salinas_input.i, targets.xml, weights.xml
    aggregation_weight 1.0
end

begin optimization_parameters
    input_file_name rol_inputs.xml
    step_tolerance 1e-10
    gradient_tolerance 1e-5
    max_iterations 10
end
