<!-- TOC -->
- trivia
- iterable bzw. interfaces allgemein

# Modifier

```java
abstract class // kann nicht instanziiert werden (z.B. nur als Oberklasse)
abstract method // placeholder

final var // Konstante
final method() // verhindert Override
final class // erlaubt keine Vererbung

static var // existiert nur einmal im speicher (unabhängig von Instanzen)
static method() // können nur auf static zugreifen, unabhängig von Instanzen
static class // nur nested classes -> unabhängig von äußerer Instanz
static {} // Wird nur beim ersten Laden der Klasse aufgeführt

volatile var // wird von mehreren Threads geteilt (nicht atomar)

synchronized method() // nur ein Thread kann gleichzeitig zugreifen
```

## Visibility

```java
public class // überall
private class // innerhalb der Klasse
protected class // innerhalb des Paketes und in Unterklassen
```





# Nested Classes
## Statische Attributklasse (static nested class)
```java
    class Outer() {
        // attr., methods ...
        static attr; // Zugriff durch Inner möglich

        static class Inner { // abstract, final | public, protected, private
            // attr., methods ...
        }
    }

    public static void main() {
        Outer.Inner x = new Outer.Inner(); // aus Sicht einer dritten Klasse
        Inner x = new Inner();
    }
```
- kann nur auf statische Elemente der Hüllenklasse (Outer) zugreifen
- Innere Klasse kann ohne ein Obj. der Hüllenklasse (Outer) instanziiert werden

Anwendung: 
- wenn eine Attributklasse nicht auf die Hüllenklasse (non-static elements) zugreifen muss -> statisch machen
- Lazy-Intialisierung



## Innere Klasse (non-static nested class)
Typen: attribut, lokal, anonym

### Attributklasse
```java
    class Innen() { // sollte private o. protected sein
        // attr., methods ...
    }

    public static void main() {
        Outer x = new Outer();
        Outer.Inner xi = x.new Inner();
    }
```
- Für Instanziierung der Inneren Klasse sit Äußere Instanz notwendig

## Lokale Klasse
- Scope einer Variable

## Anonyme Klasse
- Spezialfall lokale Klasse
- muss eine Superklasse (extends) haben o. ein Interface implementieren
- Bsp: `new Type(ctor params) { {initializer} <code> }` = `class Tmp extends Type {}`

```java
public class Anonymus {
    int val;

    public Anonymus( int i ) {
        val = i;
    }

    void print() {
        System.out.println( "val = " + val );
    }
}
new Anonymus(2).print();

new Anonymus(3) { // = class Tmp extends Anonymus {}
    final int k;

    { k = 7; }
    void print() {
        System.out.println("Anonym: " + k);
    }
}.print();
```




# Initialisierung
## Static Initialisierung
```java
public static final String NAME = "Init Demo"; // einfach
public static final String ARCH = System.getProperty("os.arch"); // mit Funktionsaufruf

// Statischer Initialisierungsblock
public static final String USER_HOME;
static {
    USER_HOME = System.getProperty("user.home");
}
```


## Non-Static Initialisierung
```java
public String description = "Ein initialisiertes Attribut"; // einfach
public long timestamp = System.currentTimeMillis(); // mit Funktionsaufruf

// Initialisierungsblock
private String userPaths;
{
    userPaths = System.getProperty("java.class.path");
}
```


## Lazy Initialisierung
- teure Obj. sollen nicht unnötig & so spät wie möglich initialisiert werden

### Variante 1
```java
class LazyInit {
    private FatClass fatObject;

    if (fatObject == null) {
        fatObject = new FatClass();
    }
    fatObject.doSomething();
}
```
- Problem: Zugriff auf Object erfolgt vllt. ohne Initialisierung bei vergessener Abfrage (if-Abfrage kann vergessen werden)

### Variante 2
```java
class LazyInitII {
    private FatClass fatObject;

    private FatClass getFatObject() {
        if (fatObject == null) {
            fatObject = new FatClass();
        }
        return fatObject;
    }

    getFatObject().doSomething();
}
```
- Vorteile: Initialisierung zentralisiert
- Problem: `getFatObject()` kann umgangen werden, Aufruf bei jeder Verwendung nötig

### Variante 3 - Holder Pattern
```java
class LazyInitIII {
    private static class Holder {
        static final FatClass fatObject = new FatClass();
    }

    Holder.fatObject.doSomething();
}
```
- funktioniert nur mit static Attr.



## for-Schleifen
### old school
```java
int a[] = 1, 2, 3, 4, 5;
int sum = 0;

for(int i = 0; i < a.length; i++) {
    sum += a[i]; // readonly
}
```

### forEach (neu)
```java
int a[] = 1, 2, 3, 4, 5;
int sum = 0;

for (int val : a) {
    sum += val; // readonly
}
```
- muss iterable implementieren
- neue Sprachfeatures werden in alten Code für Kompatibilität durch Preprocessing umgewandelt



## Varargs
### Variable Parameterliste
```java
public static int sum(int... v) {
    int sum = 0;
    for (int i : v) {
        sum += i;
    }
    return sum;
}

public static void main() {
    int s1 = sum(1, 2);
    int s2 = sum(1, 1, 2, 3, 5);
    int s3 = sum();

    int[] array = {1, 2, 3, 4};
    int s4 = sum(array);
}
```
- Nur letzter Formalparameter darf Vararg-Parameter sein


## Aufzählung (enum)
### Definition
```java
enum Seasons {
    SPRING, SUMMER, AUTUMN, WINTER;

    @Override
    public String toString() {
        if( this == SUMMER ) {
            return "Summer";
        }
        else {
            return super.toString();
        }
    }

    // um Methoden erweiterbar
    public static void main() {}
}
```

### Definition mit Konstruktor
```java
public enum Months {
    // Init mit Konstruktor
    JANUARY(31), FEBRUARY(28), MARCH(31), APRIL(30), MAY(31), JUNE(30), JULY(31), AUGUST(31),
    SEPTEMBER(30), OCTOBER(31), NOVEMBER(30), DECEMBER(31);

    private final int days;

    private Months(int days) {
        this.days = days;
    }

    public int getDays() {
        return days;
    }
}
```


## Generics
- Generics erlauben es uns, eine Klasse für verschiedene Datentypen zu verwenden

### nicht-parametrisierte Verwendung (raw type)
```java
LinkedList stringListe = new LinkedList(); // generics version
stringListe.add("Java");
stringListe.add("Programmierung");
stringListe.add(new JButton("Hi")); // fuehrt spaeter zu einer ClassCastException

for (int i=0; i<stringListe.size(); i++) {
    String s = (String) stringListe.get(i); // cast mit ClassCastException
    gesamtLaenge += s.length();
}
```
- Nachteile:
    - `get()` gibt `Object` zurück (keine Typsicherheit)
    - casten notwendig --> kann zu ClassCastException führen

### parametrisierte Verwendung
```java
import java.util.LinkedList;

LinkedList<String> stringListe = new LinkedList<String>();
stringListe.add("Hello world"); // OK
stringListe.add(new Integer( 42 )); // Compiler-NOK
String s = stringListe.get(0); // kein Cast noetig!
```
- Typsicherheit

#### Beispiel (Iterable Interface)
```java
class List<T> implements Iterable<T> {
    public Iterator<T> iterator() {
        return new Iterator<T>() {
            private ListElem<T> iter = header;
            
            public boolean hasNext() {
                return iter != null;
            }
            public T next() {
                T ret = iter.data;
                iter = iter.next;
                return ret;
            }
            public void remove() {
                throw new UnsupportedOperationException();
            }
        };
    }
}
```

- Schachtelung von Typen: `List<List<String>> var = new List<List<String>>();`
- mehrere Typ-Parameter: `public interface Map<K, V> {...}`

### Initialisierung
- `List<String> liste = new List<String>();` funktioniert nicht, da abstract (entweder LinkedList oder ArrayList)

#### ArrayList<> (mutable)
```java
List<String> sl = new ArrayList<>(Arrays.asList("ich", "bin"));
sl.add("nicht"); // allowed
sl.set(1, "nicht"); // allowed
```

#### Mit anonymer Klasse
```java
List<String> stringListe = new ArrayList<>() {{
    add("ich"); add("bin"); add("doch");
    add("nicht"); add("bloed ;-)");
}};
```

#### List.of() (immutable)
```java
List<String> sl = List.of("ich", "bin", "doch", "nicht", "bloed");
```
- ab JDK 9

### Eigene Generic Klasse
```java
class GenKlasse<T> {
    T data;
    GenKlasse(T data) {
        this.data = data;
    }
    void set(T data) {
        this.data = data;
    }
    T get() {
        return data;
    }
    public static void main(String[] args) {
        GenKlasse<String> gs = new GenKlasse<String>("Hi");
    }
}
```
- Typsicherheit zur Compilezeit, nicht Laufzeit
- Erasure: Typinformationen wird zur Laufzeit entfernt (T wird durch eigentlichen Datentyp ersetzt im kompilierten Code)


### Generics & Vererbung