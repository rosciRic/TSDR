function saveModel(model, filename)
    save(filename, 'model');
    fprintf('\nModel saved successfully as %s\n', filename);
end