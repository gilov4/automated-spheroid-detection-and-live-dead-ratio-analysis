// Fiji Macro for Combined Automated Spheroid Detection and Live/Dead Analysis
// This macro integrates spheroid detection with live/dead analysis in merged tif images.

macro "Spheroid Detection and Live/Dead Ratio Analysis - Merged tif Analysis" {
    // Initialize the console for logging progress and outputs
    run("Console");
    IJ.log("Starting spheroid detection and measurement.");

    // Create a dialog for user inputs
    Dialog.create("Spheroid Detection and Live/Dead Analysis");

    Dialog.addDirectory("Choose a directory containing the merged image files", "");
    Dialog.addDirectory("Choose a directory to save your results", "");
    Dialog.addString("Enter the file suffix filter (e.g., tif):", "tif");
    Dialog.addChoice("Do you want to use GPU for processing?", newArray("Yes", "No"), "No");

    Dialog.show();

    // Retrieve user inputs
    inputDir = Dialog.getString();
    outputDir = Dialog.getString();
    fileFilter = Dialog.getString();
    useGPU = Dialog.getChoice();

    // Convert GPU choice to boolean
    useGPU = (useGPU == "Yes");

    list = getFileList(inputDir);
    
    // Set up measurement parameters such as area and mean which will be applied in ROI manager
    run("Set Measurements...", "area mean standard modal min integrated display redirect=None decimal=3");
    print("Measurement settings applied.");

    // Iterate through each file in the directory
    for (i = 0; i < list.length; i++) {
        if (startsWith(list[i], "Merged_") && endsWith(list[i], fileFilter)) {
            processImage(inputDir, outputDir, list[i], useGPU); // Process each valid image
        }
    }
    IJ.log("Process completed for all files.");
    close("ROI Manager"); // Close ROI Manager after processing all files
    showMessage("Measurement completed for all files.");
}

function processImage(inputDir, outputDir, fileName, useGPU) {
    print("--------------------------------------------------------------------------------");
    open(inputDir + fileName); // Open image file
    orgName = getTitle(); // Get the title of the opened image
    csvName = File.getNameWithoutExtension(orgName); // Get the file name without the extension for later use
    print("Processing image file: " + orgName);

    // Set properties for the image based on the microscope calibration
    pixelWidth = 0.6192967; // Pixel width in microns, adjust as per your microscope's calibration
    pixelHeight = 0.6192967; // Pixel height in microns, consistent with pixel width
    run("Properties...", "channels=2 slices=1 frames=1 unit=um pixel_width=" + pixelWidth + " pixel_height=" + pixelHeight + " voxel_depth=1");

    // Image processing steps for detection
    run("Stack to RGB"); // Convert image stack to RGB
    run("8-bit"); // Convert the image to 8-bit
    run("Median...", "radius=10"); // Apply a median filter to reduce noise

    // Advanced cell detection using Cellpose: adjust parameters according to your sample
    if (useGPU) {
        additional_flags = "--use_gpu";
        print("Using GPU for Cellpose segmentation.");
    } else {
        additional_flags = ""; // Fall back to use CPU
        print("Using CPU for Cellpose segmentation.");
    }

    run("Cellpose Advanced", "diameter=100 cellproba_threshold=0.0 flow_threshold=0.4 anisotropy=1.0 diam_threshold=80.0 model=cyto2 nuclei_channel=0 cyto_channel=1 dimensionmode=2D stitch_threshold=-1.0 omni=false cluster=false additional_flags=" + additional_flags);
    run("Remove Border Labels", "left right top bottom"); // Remove any labels at the borders
    run("Label image to ROIs", "rm=[RoiManager[size=13, visible=true]]"); // Convert labels to ROIs
    roiManager("Save", outputDir + File.separator + orgName + ".zip"); // Save ROIs for future reference

    // Image processing for measurement
    selectWindow(orgName);
    run("Split Channels"); // Split the image into separate channels
    selectWindow("C1-" + orgName); // Select channel 1
    rename("PI_" + orgName); // Rename it for identification
    roiManager("Select All"); // Select all ROIs
    roiManager("Measure"); // Measure properties of ROIs in channel 1
    selectWindow("C2-" + orgName); // Select channel 2
    rename("FDA_" + orgName); // Rename it for identification
    roiManager("Select All"); // Select all ROIs
    roiManager("Measure"); // Measure properties of ROIs in channel 2
    
    // Clean up and save results
    roiManager("Deselect");
    roiManager("Delete");
    resultsPath = outputDir + File.separator + csvName + "_Live_Dead_Results.csv";
    saveAs("Results", resultsPath); // Save results to a CSV file
    print("Results saved to: " + resultsPath);
    close("*"); // Close all open images and windows
    close("ROI Manager");
    close("Results");
}
