<!-- TOC -->
- trivia
- iterable bzw. interfaces allgemein
- comparator allgemein

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



# for-Schleifen
## old school
```java
int a[] = 1, 2, 3, 4, 5;
int sum = 0;

for(int i = 0; i < a.length; i++) {
    sum += a[i]; // readonly
}
```

## forEach (neu)
```java
int a[] = 1, 2, 3, 4, 5;
int sum = 0;

for (int val : a) {
    sum += val; // readonly
}
```
- muss iterable implementieren
- neue Sprachfeatures werden in alten Code für Kompatibilität durch Preprocessing umgewandelt



# Varargs
## Variable Parameterliste
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


# Aufzählung (enum)
## Definition
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

## Definition mit Konstruktor
```java
public enum Months {
    // Init mit Konstruktor
    JANUARY(31), FEBRUARY(28), MARCH(31), APRIL(30), MAY(31), JUNE(30), JULY(31),
    AUGUST(31), SEPTEMBER(30), OCTOBER(31), NOVEMBER(30), DECEMBER(31);

    private final int days;

    private Months(int days) {
        this.days = days;
    }

    public int getDays() {
        return days;
    }
}
```


# Generics
- Generics erlauben es uns, eine Klasse für verschiedene Datentypen zu verwenden

## Initialisierung
- nicht erlaubt:
    - `List<String> list = new List<String>();`
    - `List list = new List();`
    - `LinkedList<String> list = new List<String>();`
    - `LinkedList list = new List();`
- funktioniert, da Interface (entweder LinkedList oder ArrayList ohne downcast)

### Imports
```java
import java.util.LinkedList;
import java.util.ArrayList;
import java.util.List;
```

### ArrayList<> (mutable)
```java
List<String> sl = new ArrayList<>(Arrays.asList("ich", "bin"));
sl.add("nicht"); // allowed
sl.set(1, "nicht"); // allowed
```

### Mit anonymer Klasse
```java
List<String> stringListe = new ArrayList<>() {{
    add("ich"); add("bin"); add("doch");
    add("nicht"); add("bloed ;-)");
}};
```

### List.of() (immutable)
```java
List<String> sl = List.of("ich", "bin", "doch", "nicht", "bloed");
```
- ab JDK 9


## nicht-parametrisierte Verwendung (raw type)
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

## parametrisierte Verwendung
```java
LinkedList<String> stringListe = new LinkedList<String>();
stringListe.add("Hello world"); // OK
stringListe.add(new Integer( 42 )); // Compiler-NOK
String s = stringListe.get(0); // kein Cast noetig!
```
- Typsicherheit

### Beispiel (Iterable Interface)
```java
import java.util.Iterator;

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


## Eigene Generic Klasse
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


## Generics & Vererbung
- A <- B: `class B extends A`
    - A ist Supertyp
    - B lässt sich zu A upcasten
- `List<a> <- List<b>?`:
```java
List<B> lb = new List<B>();
List<A> la = lb; // NOK
```
-  `List <-> List<B>` (bidirektional):
```java
ArrayList list = new ArrayList();
ArrayList<String> s_list = list;
s_list.add("hi");

ArrayList<Integer> i_list = list;
i_list.add(new Integer(3));

int len = 0;
for (String s : s_list) {
    len += s.length(); // Runtime: Cast Integer --> String!!!
}
```
    - raw types vermeiden & nicht mischen mit generics


## Array von Generics
```java
List<String> listen[] = new LinkedList<String>[5]; // error
List<String> listen[] = (LinkedList<String>[]) new List[5];
```


## Bounds
### Beschränkung des Parametertyps
- `public class List<T extends Figur> { }`
    - Figur kann Klasse, abstrakte Klasse, Interface (trotz extends) sein
    - Erasure ersetzt T durch Figur
- `public class X<T extends Number & Comparable & Iterator> { }`
    - Mehrfachbound

## Wildcards
### Upper Bound
- Ziel: Liste spezifizieren, die mit Number oder einer zu Number typ-kompatiblen Klasse (Float, Integer, ...) parametrisiert ist (upper bound)
- Nutzung: Nur Lesezugriff auf Elemente & als Parametercheck. Kein Schreibzugriff
- Kovarianz: Kann Spezialisierung verwenden (muss nicht)
- `GenTyp<? extends Number> <- GenTyp<Integer>`
- Initialisierung:
```java
List <? extends Number> dExNumber;
dExNumber = new List<Number>(); // OK
dExNumber = new List<Integer>(); // OK
dExNumber = new List<String>(); // Type Mismatch
dExNumber = new List<Object>(); // Type Mismatch
dExNumber = new List(); // Warning, because of raw type
```
- Lesezugriff:
```java
dExNumber = new List<Integer>(); // OK
for( Number n : dExNumber ); // OK, da Superklasse
for( Integer i : dExNumber ); // NOK, da Typ nicht bekannt
```
- Schreibzugriff:
```java
dExNumber.add( new Integer(3) ); // NOK
dExNumber.contains( new Integer(3) ); // NOK

Number n = new Integer(3);
dExNumber.add(n); // NOK

dExNumber.add(null); // OK
```
- kein Schreibzugriff, da Typ nicht bekannt (kann Integer, Float, ... sein)
```java
List<? extends Integer> dExInteger = new List<Integer>();
for(Integer i : dExInteger); // OK
dExInteger.add( new Integer(3) ); // NOK, da Typ unbekannt
```
- usecase - lesende Übergabe:
```java
public static double sum(List<? extends Number> numberlist) {
    double sum = 0.0;
    for (Number n : numberlist) {
        sum += n.doubleValue();
    }
    return sum;
}

public static void main(String args[]) {
    List<Integer> integerList = Arrays.asList(1, 2, 3);
    System.out.println("sum = " + sum(integerList));

    List<Double> doubleList = Arrays.asList(1.2, 2.3, 3.5);
    System.out.println("sum = " + sum(doubleList));
}
```

### Lower Bound
- Ziel: Liste spezifizieren, die mit Integer oder einem Supertyp von Integer parametrisiert ist (lower bound)
- Supertyp kann auch Interface sein
- Nutzung: Parameterchecks
- Kontravarianz: Kann allgemeineren Typ verwenden
- `GenTyp<? super Integer> <- GenTyp<Number>`
- Initialisierung:
```java
List<? super Integer> dSupInt;
dSupInt = new ArrayList<Number>(); // OK
dSupInt = new List<Integer>(); // OK
dSupInt = new List<String>(); // Type Mismatch
dSupInt = new List<Object>(); // OK, because Object is super type of Integer
dSupInt = new List(); // Warning, because of raw type
```
- Initialisierung Interfaces:
```java
dSupInt = new List<Serializable>(); // OK, da Number das Interface implementiert
dSupInt = new List<Comparable<Number>>(); // NOK, Integer implementiert nicht Comparable
dSupInt = new List<Comparable<Integer>>(); // OK, Integer implementiert Comparable
```
- Lesezugriff:
```java
for(Number n : dSupInt); // NOK
for(Object o : dSupInt); // OK
```
    - kein Lesezugriff, da Typ unbekannt & Liste könnte `Object` enthalten
- Schreibzugriff:
```java
dSupInt.add( new Integer(3) ); // OK, da mindestens Integer

Number ni = new Integer(3); // upcast
dSupInt.add(ni); // NOK

dSupInt.add(null); // OK
```
- usecase - schreibende Übergabe
```java
// usecase example - schreibende Übergabe
public static void addCat(List<? super Cat> catList) {
    catList.add(new RedCat());
}

List<Animal> animalList= new ArrayList<Animal>();
List<Cat> catList= new ArrayList<Cat>();
List<RedCat> redCatList= new ArrayList<RedCat>();

addCat(catList);
addCat(animalList); // animal is superclass of Cat

addCat(redCatList); // NOK, because Cat is superclass of RedCat
```

### Unbound
- ` List<?> l`
- readonly
- Typ wird nie festgelegt



## Generische Methoden
```java
public class GenericMax {
    public static <T extends Number & Comparable<T>> T max(T... nums) { // ... = varargs
        if (nums.length == 0)
            throw new UnsupportedOperationException(
                "Does not support empty parameter list"
            );
        
        T max = nums[0];
        for (T n : nums)
            if (max.compareTo(n) == -1)
                max = n;
        return max;
    }
    
    public static void main(String[] args) {
        Integer iArr[] = {0, 0, 1, -1, 0, -2, 3, -5, 5};
        Integer imax = max(iArr);

        Double dmax = max(-2.3, 4.555, Math.PI); // Keine casts noetig
    }
}
```




# Autoboxing
```java
public static void main() {
    List<int> lint = new List<int>(); // NOK, da primitiv

    Liste<Integer> lInteger = new Liste<Integer>();
    lInteger.add(2);
}
```
Wrapper-Klassen:
```java
int x = new Integer(5); // Autounboxing
Integer y = 6;
int z = new Integer(3) + 2;
```
    - Primitive Datentypen haben Wrapper-Klassen & sind in beide Richtungen typ-kompatibel

| PDT | Wrapperklasse |
| ----------- | ----------- |
| short | Short |
| int | Integer |
| long | Long |
| float | Float |
| double | Double |
| char | Character |
| boolean | Boolean |
| byte | Byte |


# Collections & Map
Listen:
```java
ArrayList<String> list = new ArrayList<String>(); // Seq. Array
LinkedList<String> list = new LinkedList<String>(); // doppelt verkettete Liste
Vector<String> list = new Vector<String>(); // Seq. Array
```
Maps (Paare aus Schlüssel vom Typ K und Werten von Typ V (Schlüssel eindeutig)):
```java
// Hashtabelle, zufällige Reihenfolge
HashMap<String, String> map = new HashMap<String, String>();
// Hashtabelle + doppelt verkettete Liste, eingefügte Reihenfolge
LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
// Rot-Schwarz-Baum, sortierte Reihenfolge
TreeMap<String, String> map = new TreeMap<String, String>();
```
Sets (jede Referenz darf nur einmal vorkommen):
```java
// Hashtabelle, keine Duplikate, zufällige Reihenfolge
HashSet<String> set = new HashSet<String>();
// Hashtabelle + doppelt verkettete Liste, eingefügte Reihenfolge
LinkedHashSet<String> set = new LinkedHashSet<String>();
// Rot-Schwarz-Baum, sortierte Reihenfolge
TreeSet<String> set = new TreeSet<String>();
```
Queues:
```java
LinkedList<String> queue = new LinkedList<String>(); // doppelt verkettete Liste
PriorityQueue<String> queue = new PriorityQueue<String>(); // Heap
```




# Annotations
- sind Metadaten & werden direkt vor das betreffende Element geschrieben
- Nutzen: zusätzliche Semantik, Compile-Time Checks, Code Analyse durch Tools
- Syntax Zucker - keine Funktion ohne IDE/Framework
- **Methoden** von selbstdefinierten Annotation können keine Parameter haben und keine Exceptions auslösen


## Deprecated
- markiert Methode als veraltet, nur für Kompatibilität vorhanden


## Override
- Überschreibt Elemente einer Superklasse
```java
public class Person {
    @Override
    public String getName() {
        return this.name;
    }
}
```


## SuppressWarning
- Unterdrücken Warnungen
- `@SuppressWarnings("deprecation")`
- `@SuppressWarnings({"unused","unchecked"})`


## Selbstdefinierte Annotations
Definition:
```java
public @interface Auditor {}

// mit Attribut
public @interface Copyright {
    String value();
}

// mit Default Werten
public @interface Bug { // extends Annotation
    public final static String UNASSIGNED = "[N.N.]";
    public static enum CONDITION { OPEN, CLOSED }

    // Attribute von Annotation
    int id();
    String synopsis();
    String engineer() default UNASSIGNED;
    CONDITION condition() default CONDITION.OPEN; // enum
}
```
Nutzung:
```java
@Copyright("Steven Burger")
public class Test { ... }
```


### Meta Annotationen in java.lang.annotation
- Annotationen für Annotationen

| Annotation | Bedeutung |
| ----------- | ----------- |
| `@Documented` | Docs erzeugen |
| `@Inherited` | Annotation geerbt |
| `@Retention` | Beibehaltung der Annotation `SOURCE` =nur Source, `CLASS` =Bytecode, `RUNTIME` =Laufzeit über Reflection <br> `import java.lang.annotation.RetentionPolicy` & `import java.lang.annotation.Retention`
| `@Target` | Elemente, die annotiert werden können: `TYPE` (Klassen, Interfaces, Enums), `ANNOTATION_TYPE` (Annotations), `FIELD` (Attribute), `PARAMETER`,`LOCAL_VARIABLE`, `CONSTRUCTOR`, `METHOD`, `PACKAGE` mit `import java.lang.annotation.ElementType`

### komplexes Beispiel
```java
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface Bug {
    // Constants and enums
    public final static String UNASSIGNED = "[N.N.]";
    public final static String UNDATED = "[N.N.]";
    public static enum CONDITION {OPEN, CLOSED}
    public static enum STATE {UNAPPROVED, APPROVED, ASSIGNED,
    IMPLEMENTED, TESTED, DOCUMENTED, REOPENED, WITHDRAWN,
    DUPLICATE, WILL_NOT_BE_FIXED}

    // Attributes
    int id();
    String synopsis();

    // The following attributes have defaults
    CONDITION condition() default CONDITION.OPEN;
    STATE state() default STATE.UNAPPROVED;
    String engineer() default UNASSIGNED;
    String fixedDate() default UNDATED;
}

// Einsatz
import static annotatedBugs.Bug.CONDITION;
import static annotatedBugs.Bug.STATE;

@Bug(id=378399, synopsis="Only works under Win3.11", state=STATE.WILL_NOT_BE_FIXED)
public class BugRiddled {
    int i;

    @Bug(id=339838,
    synopsis="Constructor obviously does " + "not initialize member i", state=STATE.ASSIGNED, engineer="Fourier Anna-Luise")
    void BugRiddled(int i) {
        this.i = i;
    }
}
```




# Neuerungen Java 6
- Diagnose und Management der VM mittels jconsole
- Integration von Java DB (Java implementierte relationale Datenbank) auf Basis von Apache Derby

# Neuerungen Java 7
## Strings in switch-Anweisungen
```java
private static final String IDLE = "idle";
final String terminal = "terminated";
switch (state) {
    case "busy": // fall through works as before
    case terminal: // local final variables are o.k.
    case IDLE: // constants are o.k.
    { break; }
    default: ...
}
```


## Numerische Literale
Neu: Numerische Literale dürfen Unterstriche enthalten
```java
int decimal = 42;
int hex = 0x2A;
int octal = 052;
int binary = 0b101010;

long creditCardNumber = 1234_5678_9012_3456L;
long phoneNumber = +49_789_0123_45L;
long hexWords = 0xFFEC_DE5E;
```


## Exception Handling - mehrere Typen erlaubt
Neu: mehrere Exceptions gleichzeitig abfangen
```java
File file;
try {
    file = new File(”stest.txt”);
    file.createNewFile();
}
catch(final IOException | SecurityException ex) {
    System.out.println( "multiExc: " + ex );
}
```


## Automatic Resource Management
Neu: `try` Anweisungen erzeugte Ressourcen werden autom. geschlossen, wenn das interface AutoCloseable implementiert wurde
```java
try( BufferedReader br = new BufferedReader(new FileReader("test.txt")) ) {
    br.readLine();
}
catch(final IOException ex) {
    System.out.println( " tryWith: " + ex );
}
```


## Diamond Operator
Neu: Vereinfachte Schreibweise zu Instanziierung von Generics, Typ kann auf linker Seite weggelassen werden
```java
Map<String, List<Integer> > map = new HashMap<>();
LinkedList<String> lls = new LinkedList<>();
```





# Lambdas
- namenslose anonyme Methoden
- kürzer als Verwendung von anonymer inneren Klasse
- `<Parameterliste> -> <Ausdruck> | <Block>`
- Parameter sind optional
```java
(a, b) -> a + b; // Expression Lambda
(a, b) -> {   
    return a + b; // Statement Lamda
}
() -> {
    System.out.println("Hello World");
}
```

## Functional Interfaces
### Predicate
```java
import java.util.function.Predicate;

@FuntioncalInterface
interface Predicate<T> {
    boolean test(T t);
}

Predicate<Person> checkAlter = p -> p.getAlter() >= 18;
```

Beispiel:
```java
void example(Predicate<Person> pred) {
    if(pred.test(pElem)) {
        ...
    }
}

// mit anonymer inneren Klasse
example(
    new Predicate<Person> () {
        public boolean test(Person p) {
            return p.getAge() >= 17;
        }
    }
);

// mit Lambda
example(p -> p.getAge() >= 17);
```


### Consumer
```java
import java.util.function.Consumer;

@FunctionalInterface
interface Consumer<T> {
    void accept(T t);
}

Consumer<Person> printPerson = p -> System.out.println(p);
```
Beispiel:
```java
void example(Predicate<Person> pred, Consumer<PhoneNumber> con) {
    if(pred.test(pElem)) {
        con.accept(pElem.getNumer());
    }
}

example(p -> p.getAge() >= 17, num -> {doSmthWithNum(num); });
```


### Function
```java
@FunctionalInterface
interface Function<T, R> {
    R apply(T t);
}
```
Beispiel:
```java
void example(
    Predicate<Person> pred,
    Function<Person, PhoneNumber> mapper,
    Consumer<PhoneNumber> con) {
        
    if(pred.test(pElem)) {
        PhoneNumber num = mapper.apply(p);
        con.accept(num);
    }
}

example(p -> p.getAge() >= 17, p -> p.getHomePhoneNumber(), num -> {robocall(num); });
example(p -> p.getAge() >= 16, p -> p.getMobilePhoneNumber(), num -> {txtmsg(num); });
```

### Supplier
```java
// Supplier: liefert Objekte vom Typ T
@FunctionalInterface
interface Supplier<T> {
    T get();
}
```

### BinaryOperator
```java
// BinaryOperator: zwei Objekte vom Typ T -> ein Objekt vom Typ T
@FunctionalInterface
interface BinaryOperator<T> {
    T apply(T t1, T t2);
}
```


## forEach
- Iteriert über alle Elemente, die Iterable implementiert z.B. Collections
- erwarter Consumer Interface
```java
void forEach(Consumer action)
list.forEach(p -> System.out.println(p));

/* Referenzen auf Funktionen ab Java 8 */
list.forEach(Systen.out::println);
```

## Streams
- Sequenz von Elementen, die nacheinander verarbeitet werden
- entspricht einer Pipeline: Source -> Operations -> Consumer
- **Sources**: Collection, Arrays, Files, ...
- **Intermediate-Operations**: filter(Predicate p), map(Function f), sorted(Comparator c)
- **Consumer/Terminal-Operations**: sum(T), collect(Collection), reduce(T), forEach(Consumer)
    - reduce: subtotal/akkumulator, element -> subtotal + elements

Beispiel 1:
```java
Integer sum = list.stream()
    .filter(num -> (num % 2) == 0)
    .map(num -> num * num)
    .reduce(0, (subt, num) -> subt + num);

// Mit Funktionsreferenz
sum = list.stream()
    .filter(num -> (num % 2) == 0)
    .map(num -> num * num)
    .reduce(0, Integer::sum);
```

Beispiel 2:
```java
var list = List.of("Hello", "Java", "World");
list.stream()
    .map(word -> word.toUpperCase())
    .sorted(Comparator.comparing(word -> word.length()))
    .forEach(word -> System.out.println(word));

// Mit Funktionsreferenz
var list = List.of("Hello", "Java", "World");
list.stream()
    .map(String::toUpperCase) // unbound method reference
    .sorted(Comparator.comparing(String::length)) // unbound method reference
    .forEach(System.out::println); // bound method reference to System.out object
```

### Parallel Streams
- mehrere Cores nutzen
- Vorraussetzung: unabhängig von der Reihenfolge & keine Seiteneffekte
- Rückgabe Reihefolge der Elemente kann sich ändern

Beispiel:
```java
gatherPersons().parallelStream()
    .filter(p -> p.getAge() >= 18)
    .map(p -> p.getHomePhoneNumber())
    .filter(num -> !num.isOnDoNotCallList())
    .forEach(num -> { robocall(num); });
```