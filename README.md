# automated-spheroid-detection-and-live-dead-ratio-analysis
Automated Fiji macro for spheroid detection and live/dead ratio analysis in merged tif images, utilizing Cellpose segmentation with optional GPU support.
**Example - From Left to Right: Raw → 8-bit Gray (after conversion from composite to RGB) → Cellpose Label Image.**

<div style="display: flex; justify-content: center;">
  <img src="https://github.com/Daniel-Waiger/automated-spheroid-detection/assets/55537771/f814c448-3f04-4691-aef1-e13ec4f4caf2" alt="raw-spheroid-image" style="width: 30%; vertical-align: top;" />
  <img src="https://github.com/Daniel-Waiger/automated-spheroid-detection/assets/55537771/a9703b31-aab7-448b-94f9-2cce2254ae27" alt="gray-spheroid-image" style="width: 30%; vertical-align: top;" />
  <img src="https://github.com/Daniel-Waiger/automated-spheroid-detection/assets/55537771/a21816ce-5e76-484c-8394-99b564b19451" alt="cellpose-spheroid-image" style="width: 30%; vertical-align: top;" />
</div>

# Automated Spheroid Detection and Live/Dead Ratio Analysis

This Fiji (ImageJ) macro script is designed for automated detection and analysis of spheroids in merged TIF images. The script performs the following tasks:
1. Prompts the user to select a directory containing the merged image files.
2. Processes each image in the selected directory.
3. Applies image processing steps to detect spheroids and measure fluorescence in red and green channels.
4. Uses Cellpose for spheroid detection with optional GPU support.
5. Calculates the live/dead ratios and saves results as CSV files.

## Pre-requisites
- [Fiji (ImageJ) Installation](https://fiji.sc)
- [Cellpose Installation](https://cellpose.readthedocs.io/en/latest/installation.html)
### Plugins and How to Install Them:
   - [BIOP Cellpose Wrapper Manual](https://github.com/BIOP/ijl-utilities-wrappers?tab=readme-ov-file#cellpose) - to use Cellpose Advanced in Fiji.
   - [MorphoLibJ Plugin](https://imagej.net/plugins/morpholibj) - Wiki.
      - [How to Install Plugins in Fiji](https://www.youtube.com/watch?v=DFz9xmWi63I&t=47s&ab_channel=Lost-in-the-Shell)
      - [Fiji FAQ - Quick How-to Manual](https://imagej.net/learn/faq)

## Step-by-Step Instructions

### 1. Start the Macro
1. Open Fiji (ImageJ).
2. Open the script editor (Plugins > New > Macro).
3. Copy and paste the provided macro code into the editor.
   - Or, you can drag-and-drop the macro file onto Fiji's main toolbar.

<p align="center">
  <img src="https://github.com/Daniel-Waiger/Ice-Crystal-Morphometry/assets/55537771/8abb6d99-0120-431d-898a-4f6cf91000a6" alt="Fiji Toolbar" style="width: 75%;" />
</p>
  
5. Run the macro (Run button in the script editor).

<p align="center">
  <img src="https://github.com/Daniel-Waiger/Ice-Crystal-Morphometry/assets/55537771/1882307d-c1f7-4871-a5eb-b3c939fc69a9" alt="script-editor-gui" style="width: 75%;">
</p>

### Optional GUI version:
   - This version is a one-stop shop to collect all the run parameters, and then the script runs without further dialog pop-ups.

<p align="center">
  <img src="https://github.com/Daniel-Waiger/automated-spheroid-detection-and-live-dead-ratio-analysis/assets/55537771/9a87feaf-b42f-4bd2-b359-a8d72530e131" alt="GUI version" style="width: 75%;">
</p>



## Notes

- **Adjust Calibration:** Modify `pixelWidth` and `pixelHeight` values to match your microscope's calibration.
- **Cellpose Parameters:** Customize the parameters in the `Cellpose Advanced` function to suit your specific sample type and detection requirements.
- **Output:** Ensure the directory has write permissions to save results correctly.
