function process_all_files_in_folder(input_folder)
    files = dir(fullfile(input_folder, '*.csv'));

    output_folder = fullfile(input_folder, 'Filtered');

    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    for i = 1:length(files)
        file_name = files(i).name;

        fprintf('Processing file: %s\n', file_name);

        process_seismic_data(input_folder, file_name, output_folder);
    end
end

