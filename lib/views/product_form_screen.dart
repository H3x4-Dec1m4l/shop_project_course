//Formulário da Aplicação


// import 'package:shop/utils/app_routes.dart';

import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductFormScreen extends StatefulWidget {
  // const ProductFormScreen({Key key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  //variável para controlar o botão de próximo
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _ImageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ImageURLFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as ProductModel;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageURLController.text = _formData['imageUrl'];
      }
    } else {
      _formData['price'] = '';
    }
  }

  void _updateImageUrl() {
    if (isValidImageUrl(_imageURLController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');
    return (isValidProtocol);
  }

 Future <void> _saveForm() async {
    bool _isValid = _form.currentState.validate();

    if (!_isValid) {
      return;
    }

    _form.currentState.save();

    final product = ProductModel(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );
    setState(() {
      _isLoading = true;
    });
    final products = Provider.of<ProductsProvider>(context, listen: false);
    
      try {
        if (_formData['id'] == null) {
     await products.addProduct(product);
        } else {
         await products.updateProduct(product);
        }
     Navigator.of(context).pop();
      } catch(error) {
       await showDialog<Null>(
            context: context,
            builder: ((context) => AlertDialog(
                  title: Text('Ocorreu um erro!'),
                  content: Text('$error'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )),
                );
      }finally {
        setState(() {
          _isLoading = false;
        });
        
      };
            
    //   .catchError((error) {
    //     return 
    //   }).then((_) {
        
    // } else {
    //   products.updateProduct(product);
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }
  }

  @override
  //libera a memoria consumida pelo FocusNode
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _ImageURLFocusNode.removeListener(_updateImageUrl);
    _ImageURLFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                      textInputAction: TextInputAction.next,
                      //função que ativa o botão pra ir para próximo no formulário
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value,
                      //validando entrada do usuário
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe um título válido';
                        }
                        if (value.trim().length < 3) {
                          return 'Informe um título com no mínimo 3 caracters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Preço',
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      //função que ativa o botão pra ir para próximo no formulário
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isEmptyValue =
                            newPrice == null || newPrice <= 0.98;
                        if (isEmpty || isEmptyValue) {
                          return 'Preço inválido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      // textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isValid = value.trim().length < 10;
                        if (isEmpty || isValid) {
                          return 'Digite pelo menos 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            // initialValue: _formData['imageUrl'],
                            decoration:
                                InputDecoration(labelText: 'URL da imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _ImageURLFocusNode,
                            controller: _imageURLController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) => _formData['imageUrl'] = value,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Url de Imagem inválida';
                              }
                              if (!isValidImageUrl(value)) {
                                return 'Url de Imagem inválida';
                              }
                              return null;
                            },
                          ),
                        ),
                        //controlando o quadrado onde vai ficar a previa icone
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageURLController.text.isEmpty
                              ? Text('Informe a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
