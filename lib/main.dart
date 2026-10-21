
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() =>
      _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String visor = '0';
  String expressao = '';

  double primeiroNumero = 0;
  String operacao = '';
  bool novoNumero = true;

  void pressionarNumero(String numero) {
    setState(() {
      if (novoNumero) {
        visor = numero == ',' ? '0,' : numero;
        novoNumero = false;
      } else if (numero == ',' && visor.contains(',')) {
        return;
      } else if (visor == '0' && numero != ',') {
        visor = numero;
      } else {
        visor += numero;
      }
    });
  }

  double converterNumero(String numero) {
    return double.parse(numero.replaceAll(',', '.'));
  }

  String formatarNumero(double numero) {
    if (!numero.isFinite) return 'Erro';

    if (numero == numero.truncateToDouble()) {
      return numero.toInt().toString();
    }

    return numero.toString().replaceAll('.', ',');
  }

  void selecionarOperacao(String simbolo) {
    setState(() {
      primeiroNumero = converterNumero(visor);
      operacao = simbolo;
      expressao = '$visor $simbolo';
      novoNumero = true;
    });
  }

  void calcular() {
    if (operacao.isEmpty || novoNumero) return;

    final segundoNumero = converterNumero(visor);
    double resultado;

    switch (operacao) {
      case '+':
        resultado = primeiroNumero + segundoNumero;
        break;
      case '-':
        resultado = primeiroNumero - segundoNumero;
        break;
      case '×':
        resultado = primeiroNumero * segundoNumero;
        break;
      case '÷':
        if (segundoNumero == 0) {
          setState(() {
            expressao = 'Não é possível dividir por zero';
            visor = 'Erro';
            operacao = '';
            novoNumero = true;
          });
          return;
        }
        resultado = primeiroNumero / segundoNumero;
        break;
      default:
        return;
    }

    setState(() {
      expressao = '$expressao $visor =';
      visor = formatarNumero(resultado);
      operacao = '';
      novoNumero = true;
    });
  }

  void limpar() {
    setState(() {
      visor = '0';
      expressao = '';
      primeiroNumero = 0;
      operacao = '';
      novoNumero = true;
    });
  }

  void apagarUltimo() {
    setState(() {
      if (novoNumero || visor == 'Erro') {
        visor = '0';
        novoNumero = true;
      } else if (visor.length > 1) {
        visor = visor.substring(0, visor.length - 1);
        if (visor == '-') visor = '0';
      } else {
        visor = '0';
        novoNumero = true;
      }
    });
  }

  Widget botao(
    String texto, {
    Color cor = const Color(0xFF303846),
    Color corTexto = Colors.white,
    VoidCallback? aoPressionar,
  }) {
    return SizedBox(
      height: 68,
      child: ElevatedButton(
        onPressed: aoPressionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: corTexto,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2196F3);
    const fundo = Color(0xFF171C26);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Calculadora',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      expressao,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        visor,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: botao(
                                  'C',
                                  cor: const Color(0xFF526174),
                                  aoPressionar: limpar,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: botao(
                                  '⌫',
                                  cor: const Color(0xFF526174),
                                  aoPressionar: apagarUltimo,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: botao(
                                  '÷',
                                  cor: azul,
                                  aoPressionar: () =>
                                      selecionarOperacao('÷'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: Row(
                            children: [
                              for (final n in ['7', '8', '9']) ...[
                                Expanded(
                                  child: botao(
                                    n,
                                    aoPressionar: () =>
                                        pressionarNumero(n),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: botao(
                                  '×',
                                  cor: azul,
                                  aoPressionar: () =>
                                      selecionarOperacao('×'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: Row(
                            children: [
                              for (final n in ['4', '5', '6']) ...[
                                Expanded(
                                  child: botao(
                                    n,
                                    aoPressionar: () =>
                                        pressionarNumero(n),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: botao(
                                  '-',
                                  cor: azul,
                                  aoPressionar: () =>
                                      selecionarOperacao('-'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: Row(
                            children: [
                              for (final n in ['1', '2', '3']) ...[
                                Expanded(
                                  child: botao(
                                    n,
                                    aoPressionar: () =>
                                        pressionarNumero(n),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: botao(
                                  '+',
                                  cor: azul,
                                  aoPressionar: () =>
                                      selecionarOperacao('+'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: botao(
                                  '0',
                                  aoPressionar: () =>
                                      pressionarNumero('0'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: botao(
                                  ',',
                                  aoPressionar: () =>
                                      pressionarNumero(','),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: botao(
                                  '=',
                                  cor: const Color(0xFF087FCE),
                                  aoPressionar: calcular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
