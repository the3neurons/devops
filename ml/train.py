import argparse
from azureml.core import Workspace, Experiment, ScriptRunConfig


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--workspace", required=True)
    parser.add_argument("--resource-group", required=True)
    parser.add_argument("--subscription-id", required=True)
    args = parser.parse_args()

    ws = Workspace.get(
        name=args.workspace,
        resource_group=args.resource_group,
        subscription_id=args.subscription_id,
    )
    exp = Experiment(ws, "cat-vs-dog-training")

    config = ScriptRunConfig(
        source_directory="ml",
        script="train_script.py",
        compute_target="cpu-cluster"
    )

    run = exp.submit(config)
    run.wait_for_completion(show_output=True)
    run.register_model(
        model_name="cat-vs-dog-model",
        model_path="outputs/model.joblib"
    )

if __name__ == "__main__":
    main()
