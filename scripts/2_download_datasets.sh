conda activate apptainer

RAW_DIR="datasets/raw"
mkdir -p "$RAW_DIR"


# Download raw datasets
cd "$RAW_DIR"

wget --content-disposition -O BE1_10XGenomics_count_matrices.zip \
  "https://ndownloader.figshare.com/files/42312711"
unzip -o BE1_10XGenomics_count_matrices.zip

wget -O sincell_with_class_5cl.RData \
  "https://raw.githubusercontent.com/LuyiTian/sc_mixology/master/data/sincell_with_class_5cl.RData"

# Generate processed datasets from wfsc/input_data scripts in container
cd ..

apptainer exec --bind "$(pwd)":/workspace --pwd /workspace envs/bioc_3_20_pca_wfsc.sif Rscript wfsc/input_data/BE1_input.R
apptainer exec --bind "$(pwd)":/workspace --pwd /workspace envs/bioc_3_20_pca_wfsc.sif Rscript wfsc/input_data/sc_mix_input.R
apptainer exec --bind "$(pwd)":/workspace --pwd /workspace envs/bioc_3_20_pca_wfsc.sif Rscript wfsc/input_data/cb_input.R
apptainer exec --bind "$(pwd)":/workspace --pwd /workspace envs/bioc_3_20_pca_wfsc.sif Rscript wfsc/input_data/1.3M_input.R
python - <<'PY'
import scanpy as sc
import scipy.sparse as sp

ad = sc.read_h5ad("datasets/brain_13M.h5ad")
if not sp.issparse(ad.X):
    ad.X = sp.csr_matrix(ad.X)
ad.write_h5ad("datasets/brain_13M.csr.h5ad")
PY