import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simular proceso de autenticación
      await Future.delayed(const Duration(seconds: 2));
      
      // Navegar al dashboard solo si el widget está montado
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dash');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fondo de pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/fondo.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Contenido principal
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Hero(
                      tag: 'app-logo',
                      child: Image.asset(
                        'assets/logo.webp',
                        width: 280,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Formulario
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // Campo de usuario
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su usuario';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Campo de contraseña
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botón de login animado
                    SizedBox(
                      width: 220,
                      height: 80,
                      child: InkWell(
                        onTap: _isLoading ? null : () => _handleLogin(context),
                        child: _isLoading
                            ? Lottie.asset(
                                'assets/loading.json',
                                fit: BoxFit.contain,
                              )
                            : Lottie.asset(
                                'assets/boton.json',
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}