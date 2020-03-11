import numpy as np

class PoseDataset():
    def __init__(self, directory):
        self.directory = directory

    def __getitem__(self, index):
        file_name = self.directory + '/' + str(index) + '.csv'
        example = np.genfromtxt(file_name, delimiter=',')
        point_cloud = example[:,[0,1,2]]
        heatmaps = example[:,range(3,17)]
        return point_cloud, heatmaps

    def __len__(self):
        return 10000

if __name__== "__main__":
    data = PoseDataset('/Users/matthewdaly//Programming/deepLearning/3d-pose-net/3d-pose-estimation/data/')
    pc, heatmaps = data[5555]
    print(pc.shape)
    print(pc[0,:])
    print(heatmaps.shape)
    print(heatmaps[0,5])

