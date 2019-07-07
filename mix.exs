defmodule GitDeleteSafe.MixProject do
  use Mix.Project

  def project do
    [
      app: :git_delete_safe,
      name: "Git Delete Safe",
      homepage_url: "https://github.com/lee-dohm/git-delete-safe",
      source_url: "https://github.com/lee-dohm/git-delete-safe",
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:shellwords, github: "lee-dohm/shellwords"},
      {:ex_doc, "> 0.0.0", only: :dev, runtime: false},
      {:version_tasks, "~> 0.11", only: :dev}
    ]
  end

  defp docs do
    [
      extras: [
        "README.md",
        "CODE_OF_CONDUCT.md": [
          filename: "code_of_conduct",
          title: "Code of Conduct"
        ],
        "LICENSE.md": [
          filename: "license",
          title: "License"
        ]
      ],
      main: "readme"
    ]
  end

  defp escript do
    [
      main_module: GitDeleteSafe.CLI,
      name: "git-delete-safe"
    ]
  end
end
