library country_state_city_picker_nona;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'model/select_status_model.dart' as StatusModel;

class SelectState extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String>? onStateChanged;
  final ValueChanged<String>? onCityChanged;
  final VoidCallback? onCountryTap;
  final VoidCallback? onStateTap;
  final VoidCallback? onCityTap;
  final TextStyle? style;
  final Color? dropdownColor;
  final InputDecoration decoration;
  final double spacing;
  final Color iconColor;
  final Widget? countryLogo;
  final Widget? stateLogo;

  const SelectState(
      {Key? key,
      required this.onCountryChanged,
      required this.onStateChanged,
      this.onCityChanged,
      this.decoration =
          const InputDecoration(contentPadding: EdgeInsets.all(0.0)),
      this.spacing = 0.0,
      this.style,
      this.dropdownColor,
      this.onCountryTap,
      this.onStateTap,
      this.onCityTap,
      required this.iconColor,
      this.countryLogo,
      this.stateLogo})
      : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> _cities = ["City"];
  List<String> _country = ["Country"];
  String _selectedCity = "City";
  String _selectedCountry = "Country";
  String _selectedState = "State";
  List<String> _states = ["State"];
  var responses;

  @override
  void initState() {
    getCounty();
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      if (!mounted) return;
      setState(() {
        _country.add(model.name!);
      });
    });

    return _country;
  }

  Future getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          print(statename.toString());

          _states.add(statename.toString());
        }
      });
    });

    return _states;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            print(citynames.toString());

            _cities.add(citynames.toString());
          }
        });
      });
    });
    return _cities;
  }

  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      _selectedState = "State";
      _states = ["State"];
      _selectedCountry = value;
      this.widget.onCountryChanged(value);
      getState();
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = "City";
      _cities = ["City"];
      _selectedState = value;
      this.widget.onStateChanged!(value);
      getCity();
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged!(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Row(
            children: [
              Container(
                child: widget.countryLogo,
              ),
              Flexible(
                child: InputDecorator(
                  decoration: widget.decoration,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    dropdownColor: widget.dropdownColor,
                    isExpanded: true,
                    items: _country.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                dropDownStringItem,
                                style: widget.style,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                    // onTap: ,
                    onChanged: (value) => _onSelectedCountry(value!),
                    onTap: widget.onCountryTap,
                    // onChanged: (value) => _onSelectedCountry(value!),
                    value: _selectedCountry,
                  )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: widget.spacing,
        ),
        Flexible(
          child: Row(
            children: [
              Container(
                child: widget.stateLogo,
              ),
              Flexible(
                child: InputDecorator(
                  decoration: widget.decoration,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: widget.dropdownColor,
                      isExpanded: true,
                      items: _states.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  dropDownStringItem,
                                  style: widget.style,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => _onSelectedState(value!),
                      onTap: widget.onStateTap,
                      value: _selectedState,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
