# Amazon EKSクライアントサーバ

## クライアントサーバ使用方法

### Kubernetesクラスタを作成する

1. **eksctlを実行**
   ```
   eksctl create cluster --name my-cluster --region ap-northeast-1 --nodes 2
   ```
   - `--name`：クラスター名
   - `--region`：デプロイするAWSリージョン( `ap-northeast-1` を指定)
   - `--nodes`：workerノード数(default: 2)

2. **コマンドの完了を待つ**

3. **kubectlでクラスターにアクセスできることを確認**
   ```
   kubectl get nodes
   ```
   - 下記のようにworkerノードが出力される
      ```
      $ kubectl get nodes
      NAME                                                STATUS   ROLES    AGE   VERSION
      ip-192-168-47-234.ap-northeast-1.compute.internal   Ready    <none>   10m   v1.32.3-eks-473151a
      ip-192-168-92-180.ap-northeast-1.compute.internal   Ready    <none>   10m   v1.32.3-eks-473151a
      ```
      - masterノードはAWS管理のため表示されない

### Kubernetesクラスタの情報を確認する

1. **eksctlを実行**
   ```
   eksctl get cluster --region ap-northeast-1
   ```
   - `--region`：デプロイしたAWSリージョン( `ap-northeast-1` を指定)

### Kubernetesクラスタを削除する

1. **eksctlを実行**
   ```
   eksctl delete cluster --name my-cluster --region ap-northeast-1
   ```
   - `--name`：作成したクラスター名
   - `--region`：デプロイしたAWSリージョン( `ap-northeast-1` を指定)

2. **コマンドの完了を待つ**

### 参考

- [eksctl公式ドキュメント](https://eksctl.io/)
