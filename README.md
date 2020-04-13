# Shearlet Enhanced Snapshot Compressive Imaging (SeSCI)

This is the repository for the regular paper **Shearlet Enhanced Snapshot Compressive Imaging** in the **IEEE Transactions on Image Processing (TIP)**  by [Peihao Yang](https://forsworns.github.io/), [Linghe Kong](http://www.cs.sjtu.edu.cn/~linghe.kong/), [Xiao-Yang Liu](http://www.tensorlet.com/), and [Xin Yuan](https://www.bell-labs.com/usr/x.yuan).  

### Snapshot Compressive Imaging

Snapshot compressive imaging (SCI) systems are developed to capture high-dimensional ($\geqslant3$) signals using low-dimensional off-the-shelf sensors. The multiple frames are compressed into a single measurement frame, thus saving memory, bandwidth and other resources.  The conciseness during the sampling makes it hard to reconstruct original frames. 

In this repository, we implement a reconstruction algorithm dubbed shearlet enhanced snapshot compressive imaging (SeSCI), which ensure accurate reconstruction in a short time. The performance of SeSCI origins from the joint sparsity prior on both frequency domain and shearlet domain. 

We conduct reconstruction experiments on two SCI systems named coded aperture compressive temporal imaging (CACTI) and coded aperture shapshot spectral imaging (CASSI). We compare the proposed SeSCI with other algorithms and make ablation experiments for SeSCI. We also reveal the generalization ability of SeSCI on a ghost imaging (GI) system. The related codes are listed under `experiments` folder.

Here is an example of the reconstructed image. 

<p align="center">
<img src="./figure/reconstruction.png">
</p>

<p align="center">Figure 1: A reconstruction example.</p>

### Shearlet

The shearlet is a multi-scale image transform domain, which provides directional representation of the image signals. The directional coefficients help shearlet preserve the edge information, as shown in Figure 2.  In SeSCI, we assume that the compressed frames are sparse in the frequency domain and shearlet domain. During the implementation of SeSCI, we refer to the [Shearlab](https://www3.math.tu-berlin.de/numerik/www.shearlab-old.org/index.html) library.

<p align="center">
<img src="./figure/edges.png" width="60%" height="60%" />
</p>

<p align="center">Figure 2: Shearlet preserves the edges information.</p>

### File directory

```bash
.
├── algorithms				# SeSCI implementation
├── dataset				# data mat files
├── experiments					
│   ├── ablation			# ablation experiments of SeSCI
│   ├── comparison			# comparison experiments on SCI
|   ├── extension			# an extensional experiment on GI 
│   └── sparsity			# sparsity observation
├── figure
├── results
└── utils				# utilities and other libs
```


### Usage

Get simulation dataset from [Google Drive](https://drive.google.com/open?id=1HMjf6ay6PQ379vzk8w09g6J7TxBnNjbF) or [Baidu Drive](https://pan.baidu.com/s/1Q3YeU9v4j9iQnG1dlyLDnw) (with access code ah6x). 

##### Reproducing experimental results:

- Add the root folder to the Matlab path before running any script.

- To reproduce the observation in the Sec. III A of the paper, run the scripts in `experiments/sparsity`.

- To reproduce the experiment results in the Sec. VI A of the paper, run the scripts in `experiments/comparison/simulation_cacti`.

- To reproduce the experiment results in the Sec. VI B of the paper, run the scripts in `experiments/comparison/simulation_cassi`.

- To reproduce the experiment results in the Sec. VI C of the paper, run the scripts in `experiments/ablation`.

##### Parameter tuning tips:

- The parameter `L` controls the step sizes in each iteration. The smaller `L` is, the faster  SeSCI converges.
- The $\lambda$ and $\sigma$ are used to control the denoisers on frequency domain and shearlet domain, respectively. 
- Increasing iteration number `niter` will promote the PSNR and consume more time.  

This repository only consists of the implementation and testing scripts for SeSCI. For the source codes of other algorithms in the experiments, please refer to [DeSCI](https://github.com/liuyang12/DeSCI), [GMM-TP](https://github.com/jianboyang/GMM-TP) and [MMLE-GMM](https://github.com/jianboyang/MMLE-GMM).

### Citation

```latex
@article{Peihao20SeSCI,
   author    = {Peihao, Yang and Linghe, Kong and Xiao-Yang, Liu and Xin, Yuan},
   title     = {Shearlet Enhanced Snapshot Compressive Imaging},
   journal   = {IEEE Transactions on Image Processing},
   publisher = {IEEE},
   year      = {2020},
   type      = {Journal Article}
}
```

### Contact

[Peihao Yang, SJTU](yangpeihao@sjtu.edu.cn)





