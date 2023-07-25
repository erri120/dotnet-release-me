using Avalonia.Controls;

namespace AvaloniaExample;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        TextBlock.Text = $"This was installed using {Constants.InstallationMethod}";
    }
}
