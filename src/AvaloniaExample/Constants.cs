namespace AvaloniaExample;

public static class Constants
{
#if INSTALLATION_METHOD_ARCHIVE
    public const string InstallationMethod = "Archive";
#elif INSTALLATION_METHOD_APPIMAGE
    public const string InstallationMethod = "AppImage";
#elif INSTALLATION_METHOD_FLATPAK
    public const string InstallationMethod = "Flatpak";
#elif INSTALLATION_METHOD_INNO_SETUP
    public const string InstallationMethod = "Inno Setup";
#elif INSTALLATION_METHOD_MSIX
    public const string InstallationMethod = "MSIX";
#else
    public const string InstallationMethod = "Manually";
#endif
}
