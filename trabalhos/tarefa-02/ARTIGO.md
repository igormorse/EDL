# Origem e Influências

A Linguagem Groovy foi idealizada por James Strachan em 2003. Por volta de Agosto ele publicou em um Blog pessoal sobre a nova Linguagem em que estava trabalhando, chamada Groovy. Nesta publicação ele já deixava claro quais eram as influências e objetivos para o Groovy.

``` groovy
"Linguagens de tipagens dinâmicas como Ruby e Python estão ficando bastante populares pelo visto. Eu ainda não estou convencido que todos nós devemos mover para linguagens de tipagens dinâmicas tão cedo, entretanto eu não vejo razão para que não possamos usar tanto linguagens de tipagem dinâmica quanto tipagem estática e escolher a melhor ferramenta para o trabalho."

"Eu preferiria uma Linguagem Dinâmica que executasse em cima de todo esse monte de código Java por aí e na JVM."

"Nós começaremos simples com tuplas, sequencias e mapas do Python e closures do Ruby, mantendo-se conciso, com tipagem dinâmica porém com um estilo Java."

 - James Strachan em seu Blog, Agosto de 2003
``` 

Várias versões do Groovy foram lançadas entre 2004 e 2006, porém a versão considerada **"1.0"** foi apenas lançada em Janeiro de 2007. James Strachan saiu silenciosamente do projeto um pouco antes da versão 1.0 ser lançada.

Várias linguagens influenciaram o Groovy, dentre estas **Java** , **Python** e **Ruby** estão entre as principais.

Outras linguagens que influenciaram o Groovy:

* Perl 
* PHP
* Smalltalk 
* Objective-C

# Classificação

* Tipagem Dinâmica e Estática: O Groovy foi projetado para que pudessemos escolher o melhor dos dois mundos, sendo assim, o programador possui a liberdade de escolher utilizar quaisquer desses dois recursos quando bem entender. No Java só podemos utilizar a Tipagem Estática.

**DataType.groovy** ( http://ideone.com/DzTLue )
``` Groovy
// Tipagem dinâmica
i = 10001
i = false
i = "Hello World"
// Todas as atribuições acima são válidas.


// Tipagem Estática
int j = 10

j = 300

// Atribuição inválida, j é do tipo int e não pode ser Atribuido uma String.
j = "oi"
```

Pelo exemplo acima, podemos perceber que em um mesmo código podemos misturar tanto tipagem dinâmica quanto estática sem menores problemas. Note que o código acima irá exibir um error por causa da tipagem estática que foi utilizada.

* Orientada a objetos: A linguagem Groovy é baseada no Java e apresenta grande compatibilidade com ele. O recurso da orientação a objetos, portanto, faz parte do Groovy.

* Funcional: Groovy oferece todo o recurso de programação funcional através de Closures, assim como o Java com Expressão Lambda.

* Imperativa: Podemos utilizar quaisquer recursos que uma linguagem imperativa oferece, como loops.

* Linguagem de Script: Por ser uma linguagem de script, podemos, por exemplo, utilizar o código Groovy nas aplicações Java já existentes.

**Exemplo de Java e Groovy Misturados:**

**AnimalSound.groovy** ( http://ideone.com/13Hh8E )
``` Groovy
public class AnimalSounds {

    public static void main(String[] args){     
       
        HashMap<String,String> animals = new HashMap<>();

        animals.put("Cachorro","AuAu")
        animals.put("Gato","Miau")

        animals.each{ animal, animalSound->

            System.out.println("Animal: " + animal + "\tSom: " + animalSound)

        }
    } 
}
```

# Expressividade em Relação ao Java

* A maioria dos comandos em Java podem ser utilizados no Groovy.

* O Groovy possui tipagem dinâmica e estática, verificações em tempo de execução ( Por Exemplo sobrecarga de métodos verificada em tempo de execução ) e isto não é possível em Java.

**GroovyMoreExpressive.groovy** ( http://ideone.com/SDmQYd )
``` Groovy
/**
Além da Tipagem Dinâmica, o Groovy possui suporte para Checagem de Overload em tempo de execução, 
diferentemente do Java que é apenas em tempo de compilação.

Saída:
---- Tipagem Estatica: -----
Boolean Arg.
String Arg.
Object Arg.
---- Tipagem Dinamica: -----
String Arg.
Boolean Arg.

*/

String method (Boolean arg){
	return "Boolean Arg."
}

String method(String arg){
	return "String Arg."
}

String method(Object arg){
	return "Object Arg."
}

// -- Tipagem Estática --

println "---- Tipagem Estatica: -----"

Object obj = true

println method(obj)

obj = "Igor"

println method(obj)

obj = new Object()

println method(obj)


// -- Tipagem Dinâmica

println "---- Tipagem Dinamica: -----"

dynamic = "Morse"

println method(dynamic)

dynamic = true

println method(dynamic)
```

Com isto fica claro que o Groovy é mais expressivo em relação ao Java, as poucas diferenças entre Java e Groovy conseguem ser facilmente resolvidas, como por exemplo, Inicialização de Vetores e Expressões Lambdas.

**Inicialização de Vetor em Java:**

``` Java
int[] array = {1,2,3}
```

**Inicialização de Vetor em Groovy:**

``` Groovy
// Tipagem Estática
int[] array = [1,2,3]

// Tipagem Dinâmica
array = [1,2,3]
```

* Em Groovy as Chaves ( **{ }** ) são reservadas para o uso em Closures, por isso a mudança na sintaxe.  

**Expressão Lambda em Java:**

``` Java
Runnable run = () -> System.out.println("Run");
```

**Closure em Groovy:** 

``` Groovy
Runnable run = { println 'run' }
```

* O Groovy não possui Expressões Lambda, mas isso pode ser resolvido facilmente com o uso de Closures.

# Avaliação Comparativa entre o Groovy e Java

Podemos notar grande diferença de redigibilidade entre o Groovy e o Java em um simples Hello World.

**Hello World.java** ( http://ideone.com/N2rN9J )

``` java
class HelloWorld {
  public static void main(String[] args){   
	String name = "Igor"; 
	System.out.println("Hello " + name);
  }
}  
```

**Hello World.groovy** ( http://ideone.com/OM6CF0 )
``` groovy
name = "Igor"
println "Hello, $name"
```

Ou em programas mais complexos, como por exemplo, utilizar expressões regulares para filtrar resultados em uma Lista. Neste caso é uma Lista com nomes de Wifi's. 

Os exemplos abaixo apresentarão o Código para imprimir, dado uma lista de nomes do tipo String, apenas os nomes com a seguinte formação: " UERJ- + Número de 1 a 9 + andar ". Ex: UERJ-3andar.

**regEx.java** ( http://ideone.com/QlS51U )

``` java
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/**

	Classe que filtra Lista Wifi por uma Regra de Formação Específica.

*/
class regEx {

	public static void main(String[] args){
	
		String[] wifiList = { "Subway", "FulaninhoTal", "WifiEstranho", "UERJ-6andar", "UERJ-7andar" };
		
		Pattern pattern = Pattern.compile("(UERJ-)[1-9](andar)");
	
		for (String wifi : wifiList){

			Matcher matcher = pattern.matcher(wifi);
			
			if (matcher.matches())
				System.out.println(wifi);
		
		}
	
	}
}
```

**regEx.groovy** ( http://ideone.com/3tJjEI )

``` groovy
wifiList = [ 'Subway', 'FulaninhoTal', 'WifiEstranho', 'UERJ-6andar', 'UERJ-7andar' ]

wifiList.each { wifi->

    if ( wifi ==~ /(UERJ-)[1-9](andar)/ )
	    println(wifi)
}
```


Observando os exemplos acima, temos que, sem dúvidas o Groovy possui maior facilidade para Escrita em ambos os exemplos, especialmente no de Expressão Regular. Quanto a legibilidade, apesar do exemplo de Expressão Regular do Groovy parecer ser mais legível que o Java, ambos são igualmente legíveis.

# Conclusão

Devido sua facilidade de integração o Groovy é utilizado em vários sistemas no mercado atualmente, principalmente em conjunto com sistemas em Java.

Sua facilidade de uso e seus diversos recursos para facilitar a vida do programador deixam tentador o seu uso, porém o Groovy perde um pouco no requesito performance e este pode ser considerado seu ponto negativo.

# Bibliografia

https://ideone.com/

http://groovy-lang.org/

http://radio-weblogs.com/0112098/2003/08/29.html

https://en.wikipedia.org/wiki/Groovy_(programming_language)

https://pt.wikipedia.org/wiki/Groovy

http://grails.asia/groovy-each-examples

http://bruceeckel.github.io/2015/10/17/are-java-8-lambdas-closures/