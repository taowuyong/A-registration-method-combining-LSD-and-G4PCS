# A-registration-method-combining-LSD-and-G4PCS
In this project, we provide the Matlab code of the registration method combining LSD and G4PCS algorithm. The registration method uses 3D harris keypoint detector to extract keypoints. The LoVS descriptor is calculated for each keypoint. Then, the point-to-point correspondences are established by NNSR. The rules of G4PCS algorithm are used to search correct 4-correspondence base, which are used to calculate the transformation. 

Everyone is welcome to use the code for research work, but not for commerce. If you use the code, please cite my paper (Wuyong Tao, Jingbin Liu, Dong Xu, and Yanyang Xiao (2023), Automatic registration of point clouds by
combining local shape descriptor and G4PCS algorithm, IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing, 16: 6339-6351)

In this project, four files are provided. The "ThreeDHarris_keypoint" file is used to extract keypoints. The "LRF_TOLDI" file is used to calculate the LRF of the LoVS descriptor. The "LoVS" file is used to calculate the LoVS descriptor. The “A registration method combining LSD and G4PCS” file is used to perform the registration method.

Before you carry out our algorithm, you need to calculate the point cloud resolution (pr).
