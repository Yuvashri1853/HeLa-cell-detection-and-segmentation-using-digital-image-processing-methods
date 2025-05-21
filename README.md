# HeLa-cell-detection-and-segmentation-using-digital-image-processing-methods

📘 Project Overview
This project presents a classical image processing pipeline to detect and segment HeLa cells and their nuclei from high-resolution grayscale images obtained via Serial Block Face Scanning Electron Microscopy (SBF-SEM). Unlike deep learning approaches, this work emphasizes lightweight, interpretable algorithms suitable for resource-constrained environments.


🎯 Objectives
Develop a structured image processing pipeline for HeLa cell segmentation.

Improve accuracy using preprocessing, watershed transform, and morphological operations.

Segment both cell structures and nuclei effectively.

Evaluate performance using metrics: Dice, F1 Score, Jaccard Index, and Normalized Probabilistic Rand (NPR).

Provide a lightweight alternative to deep learning methods for biomedical applications.

🧠 Methodology Summary
Cell Segmentation

Gaussian smoothing and adaptive thresholding.

Watershed-based segmentation to handle overlapping cells.

Morphological filtering to restore true cell shape.

Nucleus Segmentation

Edge detection and morphological enhancement.

Roundness-based filtering to retain valid nuclei.

Proximity and size filtering for accuracy.

Evaluation Metrics

Jaccard Index

Dice Similarity

F1 Score

NPR Index

📊 Results
The proposed algorithm outperformed a reference method across all four metrics.

Achieved consistent segmentation with improved accuracy and robustness.

Visual overlays demonstrated strong alignment with the ground truth data.

📂 Dataset
300 grayscale images (2000x2000) from Karabağ et al.

Publicly available with ground truth annotations for both cells and nuclei.


📌 Conclusion
This project successfully demonstrates an efficient and interpretable classical image processing approach for HeLa cell and nucleus segmentation. Future improvements could target generalization to other cell types, inclusion of intracellular organelles, and real-time biomedical imaging tools.
