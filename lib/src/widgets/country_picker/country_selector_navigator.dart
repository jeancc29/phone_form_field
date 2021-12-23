import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/src/helpers/country_translator.dart';

import '../../models/all_countries.dart';
import '../../models/country.dart';
import 'country_selector.dart';

abstract class CountrySelectorNavigator {
  final List<Country>? countries;
  final List<String>? favorites;
  final bool addSeparator;
  final bool showCountryCode;
  final bool sortCountries;
  final String? noResultMessage;
  final bool searchAutofocus;

  const CountrySelectorNavigator({
    this.countries,
    this.favorites,
    this.addSeparator = true,
    this.showCountryCode = true,
    this.sortCountries = false,
    this.noResultMessage,
    required this.searchAutofocus,
  });

  Future<Country?> navigate(BuildContext context);

  CountrySelector _getCountrySelector({
    required ValueChanged<Country> onCountrySelected,
    ScrollController? scrollController,
  }) =>
      CountrySelector(
        countries: countries ?? allCountries,
        onCountrySelected: onCountrySelected,
        favoriteCountries: favorites ?? [],
        addFavoritesSeparator: addSeparator,
        showCountryCode: showCountryCode,
        sortCountries: sortCountries,
        noResultMessage: noResultMessage,
        scrollController: scrollController,
        searchAutofocus: searchAutofocus,
      );
}

class DialogNavigator extends CountrySelectorNavigator {
  const DialogNavigator(
      {List<Country>? countries,
      List<String>? favorites,
      bool addSeparator = true,
      bool showCountryCode = true,
      bool sortCountries = false,
      String? noResultMessage,
      bool searchAutofocus = kIsWeb})
      : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
        );

  @override
  Future<Country?> navigate(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: _getCountrySelector(
          onCountrySelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}

class BottomSheetNavigator extends CountrySelectorNavigator {
  const BottomSheetNavigator(
      {List<Country>? countries,
      List<String>? favorites,
      bool addSeparator = true,
      bool showCountryCode = true,
      bool sortCountries = false,
      String? noResultMessage,
      bool searchAutofocus = kIsWeb})
      : super(
            countries: countries,
            favorites: favorites,
            addSeparator: addSeparator,
            showCountryCode: showCountryCode,
            sortCountries: sortCountries,
            noResultMessage: noResultMessage,
            searchAutofocus: searchAutofocus);

  @override
  Future<Country?> navigate(BuildContext context) {
    Country? selected;
    final ctrl = showBottomSheet(
      context: context,
      builder: (_) => _getCountrySelector(
        onCountrySelected: (country) {
          selected = country;
          Navigator.pop(context, country);
        },
      ),
    );
    return ctrl.closed.then((_) => selected);
  }
}

class ModalBottomSheetNavigator extends CountrySelectorNavigator {
  final double? height;

  const ModalBottomSheetNavigator({
    this.height,
    List<Country>? countries,
    List<String>? favorites,
    bool addSeparator = true,
    bool showCountryCode = true,
    bool sortCountries = false,
    String? noResultMessage,
    bool searchAutofocus = kIsWeb,
  }) : super(
            countries: countries,
            favorites: favorites,
            addSeparator: addSeparator,
            showCountryCode: showCountryCode,
            sortCountries: sortCountries,
            noResultMessage: noResultMessage,
            searchAutofocus: searchAutofocus);

  @override
  Future<Country?> navigate(BuildContext context) {
    return showModalBottomSheet<Country>(
      context: context,
      builder: (_) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height - 90,
        child: _getCountrySelector(
          onCountrySelected: (country) => Navigator.pop(context, country),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class DraggableModalBottomSheetNavigator extends CountrySelectorNavigator {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final BorderRadiusGeometry? borderRadius;

  const DraggableModalBottomSheetNavigator(
      {this.initialChildSize = 0.5,
      this.minChildSize = 0.25,
      this.maxChildSize = 0.85,
      this.borderRadius,
      List<Country>? countries,
      List<String>? favorites,
      bool addSeparator = true,
      bool showCountryCode = true,
      bool sortCountries = false,
      String? noResultMessage,
      bool searchAutofocus = kIsWeb})
      : super(
            countries: countries,
            favorites: favorites,
            addSeparator: addSeparator,
            showCountryCode: showCountryCode,
            sortCountries: sortCountries,
            noResultMessage: noResultMessage,
            searchAutofocus: searchAutofocus);

  @override
  Future<Country?> navigate(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        );
    return showModalBottomSheet<Country>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveBorderRadius,
              ),
            ),
            child: _getCountrySelector(
              onCountrySelected: (country) => Navigator.pop(context, country),
              scrollController: scrollController,
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}


class PopupNavigator extends CountrySelectorNavigator {
  const PopupNavigator(
      {List<Country>? countries,
      List<String>? favorites,
      bool addSeparator = true,
      bool showCountryCode = true,
      bool sortCountries = false,
      String? noResultMessage,
      bool searchAutofocus = kIsWeb})
      : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
        );

  @override
  Future<Country?> navigate(BuildContext context, [Offset offset = const Offset(100, 100)]) {
    // return showDialog(
    //   context: context,
    //   builder: (_) => Dialog(
    //     child: _getCountrySelector(
    //       onCountrySelected: (country) => Navigator.pop(context, country),
    //     ),
    //   ),
    // );

    double left = offset.dx;
    double top = offset.dy;
    var countriesTmp = countries ?? allCountries;

    return showMenu<Country>(
        context: context,
        position: RelativeRect.fromLTRB(left, top, 100, 100),
        items: 
        // [
        //   PopupMenuItem(
        //     value: 1,
        //     child: Text("View"),
        //   ),
        //   PopupMenuItem(
        //      value: 2
        //     child: Text("Edit"),
        //   ),
        //   PopupMenuItem(
        //     value: 3
        //     child: Text("Delete"),
        //   ),
        // ],
        countriesTmp.asMap().map((index, value){
          

     
        Country country = countriesTmp[index];

        return MapEntry(index, PopupMenuItem(
          value: value,
          child: ListTile(
            key: Key(country.isoCode),
            leading: CircleFlag(
              country.isoCode,
              size: 40,
            ),
            title: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                CountryTranslator.localisedName(context, country),
                textAlign: TextAlign.start,
              ),
            ),
            subtitle: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      country.displayCountryCode,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                    ),
                  )
               ,
            // onTap: () => onTap(country),
          ),
        ));
        }).values.toList()
        ,
        elevation: 8.0,
      );
  }
}