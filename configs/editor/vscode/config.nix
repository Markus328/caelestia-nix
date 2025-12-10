{
  lib,
  pkgs,
  ...
}: {
  package = pkgs.vscodium;

  # Using a profile other than default probably will break the caelestia-integration extension
  profiles.default = {
    userSettings = {
      "[c]" = {
        "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      };
      "[cpp]" = {
        "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      };
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };
      "codeium.enableCodeLens" = false;
      "codeium.enableConfig" = {
        "*" = true;
        fish = true;
        qml = true;
      };
      "diffEditor.hideUnchangedRegions.enabled" = true;
      "doxdocgen.generic.boolReturnsTrueFalse" = false;
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "explicit";
      };
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.inlayHints.enabled" = "off";
      "editor.minimap.autohide" = "mouseover";
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.renderWhitespace" = "trailing";
      "editor.smoothScrolling" = true;
      "editor.suggestSelection" = "recentlyUsedByPrefix";
      "git.enableSmartCommit" = true;
      "javascript.preferences.importModuleSpecifierEnding" = "minimal";
      "prettier.arrowParens" = "avoid";
      "prettier.printWidth" = 120;
      "prettier.tabWidth" = 4;
      "python.languageServer" = "Pylance";
      "qt-qml.doNotAskForQmllsDownload" = true;
      # "qt-qml.qmlls.additionalImportPaths" = ["/usr/lib/qt6/qml"];
      # "qt-qml.qmlls.customExePath" = "${pkgs.kdePackages.qtdeclarative}/qmlls";
      "ruff.lineLength" = 120;
      "security.workspace.trust.startupPrompt" = "always";
      "terminal.integrated.enableMultiLinePasteWarning" = "never";
      "terminal.integrated.smoothScrolling" = true;
      "typescript.preferences.importModuleSpecifierEnding" = "minimal";
      "typescript.preferences.preferTypeOnlyAutoImports" = true;
      "workbench.colorTheme" = "Caelestia";
      "workbench.iconTheme" = "catppuccin-mocha"; # This will not change automatically for light mode
      "workbench.list.smoothScrolling" = true;
    };

    keybindings = [
      {
        command = "workbench.action.reloadWindow";
        key = "ctrl+shift+alt+r";
      }
      {
        command = "workbench.action.previousEditor";
        key = "ctrl+pageup";
      }
      {
        command = "workbench.action.nextEditor";
        key = "ctrl+pagedown";
      }
      {
        command = "editor.action.moveLinesUpAction";
        key = "ctrl+shift+up";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        command = "editor.action.moveLinesDownAction";
        key = "ctrl+shift+down";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        command = "editor.action.insertCursorAbove";
        key = "shift+alt+up";
        when = "editorTextFocus";
      }
      {
        command = "editor.action.insertCursorBelow";
        key = "shift+alt+down";
        when = "editorTextFocus";
      }
    ];

    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc-icons
      llvm-vs-code-extensions.vscode-clangd
      charliermarsh.ruff
      esbenp.prettier-vscode
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "qt-qml";
          publisher = "TheQtCompany";
          version = "1.11.0";
          hash = "sha256-sFFFWvoEiFqEvlX28rohbaKWZamhKa0iFIZJ6h7K77A=";
        };
      })
    ];
  };
}
