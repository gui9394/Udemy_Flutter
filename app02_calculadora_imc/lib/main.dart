import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weigthController = TextEditingController();
  TextEditingController heigthController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();

  String _info = "Informe seus dados!";

  void _resetFields() {
    weigthController.text = "";
    heigthController.text = "";
    setState(() {
      _info = "Informe seus dados!";
    });
  }

  void _calculate() {
    setState(() {
      double weigth = double.parse(weigthController.text);
      double heigth = double.parse(heigthController.text) / 100;
      double imc = weigth / (heigth * heigth);

      String msg;

      if (imc < 18.6) {
        msg = "Abaixo do peso";
      } else if (imc < 24.9) {
        msg = "Peso ideal";
      } else if (imc < 29.9) {
        msg = "Levemente acima do peso";
      } else if (imc < 34.9) {
        msg = "Obesidade grau I";
      } else if (imc < 39.9) {
        msg = "Obesidade grau II";
      } else {
        msg = "Obesidade grau III";
      }

      _info = "$msg (${imc.toStringAsPrecision(3)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.person, size: 120.0, color: Colors.green),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Peso (kg)",
                              labelStyle: TextStyle(color: Colors.green)),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 25.0),
                          controller: weigthController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Insira seu peso";
                            }
                          }),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Altura (cm)",
                              labelStyle: TextStyle(color: Colors.green)),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 25.0),
                          controller: heigthController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Insira sua altura";
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _calculate();
                                }
                              },
                              child: Text("Calcular",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0)),
                              color: Colors.green,
                            )),
                      ),
                      Text(_info,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 25.0))
                    ]))));
  }
}
