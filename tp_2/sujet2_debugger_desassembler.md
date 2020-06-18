# Sujet 2 : Débugger et désassembler des programmes compilés

## Présentation du sujet

Quelques définitions s'imposent :

- débugger

   : exécuter un programme "pas à pas", c'est à dire instruction par instruction

  - cela permet de voir l'état des variables internes au programme en temps réel
  - cela peut aussi permettre de modifier le comportement du programme à la volée, pendant son exécution

- désassembler

   : regarder le code machine (l'assembleur) d'un programme compilé

  - on peut alors étudier la logique interne du programme

Ce sujet sera donc dédié à l'assembleur, mais plutôt sur l'étude de codes déjà écrits, *via* l'utilisation d'outils permettant de débugger ou désassembler des programmes. Ce sont un peu les rudiments d'une discipline de la sécurité offensive appelée *cracking*.

## Préliminaire

- logique booléenne
  - strictement essentiel d'avoir en tête le principe de la logique booléenne
    - valeurs "vrai" ou "faux"
    - opérations logiques "et", "ou" et "non"
- instructions assembleur basique
  - arithmétique
    - ADD, MUL, etc
  - logique
    - AND, OR, NOT

Vous aurez besoin d'un débuggeur et un désassembleur pour ce sujet. Il en existe des tas, je vous conseille :

- débugger : gdb (avec gdb-peda éventuellement)
- désassembleur : ghidra ou IDA

## Exercices

### Hello World

- commencer par coder puis compiler un programme Hello World en C
  - ce programme doit simplement afficher "Hello World!" dans le terminal lorsqu'il est lancé

```c
➜  exo git:(master) ✗ cat hello.c
#include <stdio.h>
int main() {
   // printf() displays the string inside quotation
   printf("Hello, World!");
   return 0;
}
```

```bash
➜  exo git:(master) ✗ gcc hello.c -v
Apple LLVM version 10.0.1 (clang-1001.0.46.4)
Target: x86_64-apple-darwin18.7.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 "/Library/Developer/CommandLineTools/usr/bin/clang" -cc1 -triple x86_64-apple-macosx10.14.0 -Wdeprecated-objc-isa-usage -Werror=deprecated-objc-isa-usage -emit-obj -mrelax-all -disable-free -disable-llvm-verifier -discard-value-names -main-file-name hello.c -mrelocation-model pic -pic-level 2 -mthread-model posix -mdisable-fp-elim -fno-strict-return -masm-verbose -munwind-tables -target-sdk-version=10.14 -target-cpu penryn -dwarf-column-info -debugger-tuning=lldb -target-linker-version 450.3 -v -resource-dir /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -I/usr/local/include -Wno-atomic-implicit-seq-cst -Wno-framework-include-private-from-public -Wno-atimport-in-framework-header -Wno-quoted-include-in-framework-header -fdebug-compilation-dir /Users/marie/Documents/ynov_2019_2020/reseau/mastering-host/tp_2/exo -ferror-limit 19 -fmessage-length 80 -stack-protector 1 -fblocks -fencode-extended-block-signature -fregister-global-dtors-with-atexit -fobjc-runtime=macosx-10.14.0 -fmax-type-align=16 -fdiagnostics-show-option -fcolor-diagnostics -o /var/folders/66/399w_kzd2c53xh83cbp23cnr0000gn/T/hello-1abc11.o -x c hello.c
clang -cc1 version 10.0.1 (clang-1001.0.46.4) default target x86_64-apple-darwin18.7.0
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/local/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /usr/local/include
 /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1/include
 /Library/Developer/CommandLineTools/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks (framework directory)
End of search list.
 "/Library/Developer/CommandLineTools/usr/bin/ld" -demangle -lto_library /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib -no_deduplicate -dynamic -arch x86_64 -macosx_version_min 10.14.0 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -o a.out /var/folders/66/399w_kzd2c53xh83cbp23cnr0000gn/T/hello-1abc11.o -L/usr/local/lib -lSystem /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1/lib/darwin/libclang_rt.osx.a
```

```bash
➜  exo git:(master) ✗ gcc hello.c -o helloworld
```

- désassembler le programme et mettre en évidence

  -> où est stockée la chaîne de caractère "Hello World"

```bash
➜  exo git:(master) ✗ gdb -q ./helloworld
Reading symbols from ./helloworld...
(No debugging symbols found in ./helloworld)
(gdb) disas main
Dump of assembler code for function main:
   0x0000000100000f60 <+0>:	push   %rbp
   0x0000000100000f61 <+1>:	mov    %rsp,%rbp
   0x0000000100000f64 <+4>:	sub    $0x10,%rsp
   0x0000000100000f68 <+8>:	movl   $0x0,-0x4(%rbp)
   0x0000000100000f6f <+15>:	lea    0x34(%rip),%rdi        # 0x100000faa
   0x0000000100000f76 <+22>:	mov    $0x0,%al
   0x0000000100000f78 <+24>:	callq  0x100000f8a
   0x0000000100000f7d <+29>:	xor    %ecx,%ecx
   0x0000000100000f7f <+31>:	mov    %eax,-0x8(%rbp)
   0x0000000100000f82 <+34>:	mov    %ecx,%eax
   0x0000000100000f84 <+36>:	add    $0x10,%rsp
   0x0000000100000f88 <+40>:	pop    %rbp
   0x0000000100000f89 <+41>:	retq
End of assembler dump.
(gdb) q
```

​	-> comment elle est affichée dans le terminal

```bash
➜  exo git:(master) ✗ ./a.out
Hello, World!%
```

### Winrar crack

Winrar est un programme qui permet de manipuler des archives (`.rar`, `.zip`, etc).

Winrar est un programme payant qui possède une version d'évaluation. Une fois cette période d'évaluation dépassée, le programme nous rappelle régulièrent qu'il est nécessaire d'acheter le produit pour continuer à l'acheter (oupa).

Le but de cette section est de crack Winrar afin d'avoir une version utilisable comme une version achetée. (j'ai testé avec la version que j'avais sous la main : 5.4)

Il existe 10000 tutos pour crack Winrar sur le web, je vous laisse partir sur ça. C'est un peu le cas d'école de référence :)