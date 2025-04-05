Future<ImageModel?> filePicker({required BuildContext context}) async {
  try {
    // Check storage permission
    final permissionStatus = await Permission.storage.status;

    if (!permissionStatus.isGranted && !permissionStatus.isLimited) {
      final requested = await Permission.storage.request();

      if (requested.isDenied || requested.isPermanentlyDenied) {
        await showCustomDialog(
          context: context,
          message: "Storage permission is required to pick files. Please enable it from settings.",
          dialogType: DialogType.warning,
        );
        openAppSettings();
        return null;
      }
    }

    // Pick file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true, // ensures `bytes` is not null
    );

    if (result == null) {
      await showCustomDialog(
        context: context,
        message: "No file was selected.",
        dialogType: DialogType.info,
      );
      return null;
    }

    // Ensure file has bytes
    if (result.files.first.bytes == null) {
      await showCustomDialog(
        context: context,
        message: "Unable to read the selected file. Try again.",
        dialogType: DialogType.error,
      );
      return null;
    }

    // Convert to base64
    final base64 = base64Encode(result.files.first.bytes!);
    final fileName = result.files.first.name;

    return ImageModel(base64String: base64, fileName: fileName);
  } catch (e) {
    debugPrint("File Picker Error: $e");
    await showCustomDialog(
      context: context,
      message: "Something went wrong while picking the file.",
      dialogType: DialogType.error,
    );
    return null;
  }
}
