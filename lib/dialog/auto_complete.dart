import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:weather/configs/app_const.dart';

class AutoComplete {
  final BuildContext context;
  AutoComplete(this.context);

  Future<Prediction?> showAutocompleteDialog() async {
    TextEditingController controller = TextEditingController();
    Prediction? selectedPrediction;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Search Location",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GooglePlaceAutoCompleteTextField(
                  textEditingController: controller,
                  inputDecoration: InputDecoration(
                    hintText: "Search location...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  boxDecoration: BoxDecoration(),
                  googleAPIKey: AppConst.googleApiKey,
                  isLatLngRequired: true,
                  showError: false,
                  getPlaceDetailWithLatLng: (postalCodeResponse) {
                    selectedPrediction = postalCodeResponse;
                    Navigator.pop(dialogContext);
                  },
                  itemClick: (prediction) {
                    // Handle item click if needed
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        if (selectedPrediction != null) {
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: const Text(
                        "Select",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return selectedPrediction;
  }
}
