# Sujet 5 : Manipulations autour des appels système

## Présentation du sujet

Ici vous allez explorer les appels système réalisés par un OS GNU/Linux afin de comprendre un peu mieux :

- les interactions entre l'OS et le noyau
- le rôle du noyau
- comment votre espace utilisateur fonctionne

## Préliminaire

Une VM GNU/Linux, n'importe laquelle.

Quelques recherches sur l'utilité et le fonctionnement des syscalls.

## Intro aux syscalls

Un *syscall* (ou appel système en fraçais) est une fonction exposée par le kernel, dans le but d'être utilisée par l'OS ou ses applications. Par extension, c'est donc tout ce qu'il est capable de demander au kernel.

L'OS étant manipulé par les applications et l'utilisateur, les syscalls représentent notamment toutes les opérations qu'un utilisateur peut effectuer sur un système.

La liste des syscalls est plutôt longue, en voici quelques exemples :

- `open()` ouvrir un fichier
- `read()` lire un fichier
- `fork()` créer un nouveau processus
- `mmap()` charger en RAM un fichier (ou une partie de fichier)
- `setuid()` interagir avec le *setuid bit* des fichiers
- `chown()` changer le propriétaire d'un fichier

## Exercices

Pour les exercices vous pouvez utiliser la commande `strace` afin de tracer les appels système effectués par une application donnée. Utilisation :

```shell
# Lire un fichier
$ cat /tmp/testfile

# Lire un fichier et tracer les appels système que le programme 'cat' effectue
$ strace cat /tmp/testfile

# Lire un fichier, tracer les syscalls, et les enregistrer dans un fichier plutôt qu'un affichage dans le terminal
$ strace -o /tmp/output_file cat /tmp/testfile
```

------

La plupart des exercices consistent à taper une commande, enregistrer ("tracer") tous les appels système qu'elle effectue, puis analyser le résultat.

J'utilise la formulation ***"mettre en évidence les principaux syscalls"***. Cela veut dire :

- les syscalls vraiment essentiels au bon fonctionnement de la commande
  - il y en a peu pour chacune des commandes
  - essayez d'en comprendre le plus possible, pour extrare l'essentiel de façon pertinente
- par exemple, pour une lecture de fichier on va chercher par exemple :
  - le syscall qui lit le fichier
  - le syscall qui permet d'afficher le contenu dans le terminal
  - le syscall qui effectue un test de permission

J'attends de vous de :

- pour chaque syscall
  - donner le nom du syscall
  - donner sa fonction, son utilité
  - expliquer tous ses arguments
- vous pouvez m'afficher le `strace` complet, puis un `strace` allégé où ne figurent que les syscalls principaux

### Exo 1 : Lecture d'un fichier

Mettre en évidence les principaux syscalls lors d'une commande `cat <FICHIER>`.

```shell
# Commande réalisé :
[mdugoua@localhost ~]$ strace cat /tmp/testFile
```

```shell
# Resultats obtenue :

# Recherche et ouverture des fichiers necessaire a l'utilisation de cat
execve("/usr/bin/cat", ["cat", "/tmp/testFile"], 0x7ffc7697d198 /* 26 vars */) = 0
brk(NULL)                               = 0x783000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9db5e1b000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f9db5e16000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f9db582d000
mprotect(0x7f9db59f0000, 2097152, PROT_NONE) = 0
mmap(0x7f9db5bf0000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7f9db5bf0000
mmap(0x7f9db5bf6000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f9db5bf6000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9db5e15000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9db5e13000
arch_prctl(ARCH_SET_FS, 0x7f9db5e13740) = 0
mprotect(0x7f9db5bf0000, 16384, PROT_READ) = 0
mprotect(0x60b000, 4096, PROT_READ)     = 0
mprotect(0x7f9db5e1c000, 4096, PROT_READ) = 0
munmap(0x7f9db5e16000, 18769)           = 0
brk(NULL)                               = 0x783000
brk(0x7a4000)                           = 0x7a4000
brk(NULL)                               = 0x7a4000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f9daf303000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9db5e1a000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f9db5e1a000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
```

```shell
# Il ouvre le fichier testFile
open("/tmp/testFile", O_RDONLY)         = 3
# fstat() -> cherche apres ouverture a obtenir le status du fichier.
fstat(3, {st_mode=S_IFREG|0664, st_size=9, ...}) = 0
# fadvise64() -> annonce l'intention d'accéder au données du fichier
fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
# read() lit le contenue du fichier
read(3, "Hello !!\n", 65536)            = 9
# write() ecrit le contenue du fichier
write(1, "Hello !!\n", 9Hello !!
)               = 9
read(3, "", 65536)                      = 0
close(3)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

### Exo 2 : Modification d'un fichier

Mettre en évidence les principaux syscalls lors de :

```shell
# Cas 1 : écriture depuis la ligne de commande
echo "test" > /tmp/testfile

# Cas 2 : écriture avec un éditeur de texte
vim /tmp/testfile
```

```shell
# Cas 1 : écriture depuis la ligne de commande
[mdugoua@localhost ~]$ strace -o /tmp/outputFile  echo "test" > /tmp/testFile

[mdugoua@localhost ~]$ cat /tmp/outputFile

execve("/usr/bin/echo", ["echo", "test"], 0x7fff931b3548 /* 26 vars */) = 0
brk(NULL)                               = 0xf27000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9f62015000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f9f62010000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f9f61a27000
mprotect(0x7f9f61bea000, 2097152, PROT_NONE) = 0
mmap(0x7f9f61dea000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7f9f61dea000
mmap(0x7f9f61df0000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f9f61df0000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9f6200f000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9f6200d000
arch_prctl(ARCH_SET_FS, 0x7f9f6200d740) = 0
mprotect(0x7f9f61dea000, 16384, PROT_READ) = 0
mprotect(0x606000, 4096, PROT_READ)     = 0
mprotect(0x7f9f62016000, 4096, PROT_READ) = 0
munmap(0x7f9f62010000, 18769)           = 0
brk(NULL)                               = 0xf27000
brk(0xf48000)                           = 0xf48000
brk(NULL)                               = 0xf48000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f9f5b4fd000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9f62014000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f9f62014000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
fstat(1, {st_mode=S_IFREG|0664, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f9f62014000
write(1, "test\n", 5)                   = 5
close(1)                                = 0
munmap(0x7f9f62014000, 4096)            = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

**Hint** : pour le cas 2, vous pouvez :

```shell
# Dans un premier terminal
# Il servira à utiliser vim, et à générer le fichier contenant tous les syscalls
$ strace -o /tmp/output_file vim /tmp/testfile

# Dans un deuxième terminal, il servira à visualiser en temps réel les syscalls enregistrés
$ tail -f /tmp/output_file
```

```shell
# Cas 2 : écriture avec un éditeur de texte
[mdugoua@localhost ~]$ strace -o /tmp/outputFile  vi /tmp/testFile

[mdugoua@localhost ~]$ tail -f /tmp/outputFile
write(1, "\33[?25l \33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 0 (Timeout)
lseek(4, 4096, SEEK_SET)                = 4096
write(4, "tp\1\0\177\0\0\0\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(4, 8192, SEEK_SET)                = 8192
write(4, "ad\0\0\332\17\0\0\372\17\0\0\0\20\0\0\1\0\0\0\0\0\0\0\372\17\0\0\373\17\0\0"..., 4096) = 4096
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
fsync(4)                                = 0
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\r", 250)                      = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[2;1H\33[K\33[2;1H\33[?12l\33[?25"..., 33) = 33
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=2, tv_usec=910649})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "h", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25lh\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=620546})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "e", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25le\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=2, tv_usec=718378})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "l", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25ll\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=834979})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "l", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25ll\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=617539})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "i", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25li\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=33190})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "!", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l!\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=2, tv_usec=711757})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\r", 250)                      = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[3;1H\33[K\33[3;1H\33[?12l\33[?25"..., 33) = 33
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=153548})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\177", 250)                    = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[94m~                    "..., 141) = 141
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=715816})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\177", 250)                    = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[m\33[2;6H\33[K\33[2;6H\33[?12l\33["..., 36) = 36
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=652946})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\177", 250)                    = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[2;5H\33[K\33[2;5H\33[?12l\33[?25"..., 33) = 33
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=278501})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "o", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25lo\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=128917})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "!", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l!\33[?12l\33[?25h", 19) = 19
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=576557})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\r", 250)                      = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[3;1H\33[K\33[3;1H\33[?12l\33[?25"..., 33) = 33
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 0 (Timeout)
lseek(4, 8192, SEEK_SET)                = 8192
write(4, "ad\0\0\312\17\0\0\362\17\0\0\0\20\0\0\3\0\0\0\0\0\0\0\372\17\0\0\363\17\0\0"..., 4096) = 4096
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
lseek(4, 4096, SEEK_SET)                = 4096
write(4, "tp\1\0\177\0\0\0\2\0\0\0\0\0\0\0\3\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"..., 4096) = 4096
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
fsync(4)                                = 0
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\33", 250)                     = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=25000}) = 0 (Timeout)
write(1, "\33[59;1H\33[K\33[3;1H", 16)  = 16
select(1, [0], NULL, [0], {tv_sec=1, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l", 6)                 = 6
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?12l\33[?25h", 12)        = 12
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=487651})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, ":", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?25l\33[59;1H:", 14)      = 14
ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost -isig -icanon -echo ...}) = 0
ioctl(0, TCGETS, {B38400 opost -isig -icanon -echo ...}) = 0
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\33[?12l\33[?25h", 12)        = 12
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=2, tv_usec=972301})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "w", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "w", 1)                        = 1
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=781506})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "q", 250)                       = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "q", 1)                        = 1
select(1, [0], NULL, [0], {tv_sec=4, tv_usec=0}) = 1 (in [0], left {tv_sec=3, tv_usec=88885})
select(1, [0], NULL, [0], NULL)         = 1 (in [0])
read(0, "\r", 250)                      = 1
select(1, [0], NULL, [0], {tv_sec=0, tv_usec=0}) = 0 (Timeout)
write(1, "\r", 1)                       = 1
stat("/tmp/testFile", {st_mode=S_IFREG|0664, st_size=4, ...}) = 0
access("/tmp/testFile", W_OK)           = 0
write(1, "\33[?25l", 6)                 = 6
ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
write(1, "\"/tmp/testFile\"", 15)       = 15
stat("/tmp/testFile", {st_mode=S_IFREG|0664, st_size=4, ...}) = 0
access("/tmp/testFile", W_OK)           = 0
getxattr("/tmp/testFile", "system.posix_acl_access", 0x7ffdd8079760, 132) = -1 ENODATA (No data available)
stat("/tmp/testFile", {st_mode=S_IFREG|0664, st_size=4, ...}) = 0
fsync(4)                                = 0
open("/tmp/testFile", O_WRONLY|O_CREAT|O_TRUNC, 0664) = 3
write(3, "hi!  \nhello!\n\n", 14)       = 14
fsync(3)                                = 0
close(3)                                = 0
chmod("/tmp/testFile", 0100664)         = 0
setxattr("/tmp/testFile", "system.posix_acl_access", "\2\0\0\0\1\0\6\0\377\377\377\377\4\0\6\0\377\377\377\377 \0\4\0\377\377\377\377", 28, 0) = 0
write(1, " 3L, 14C written", 16)        = 16
lseek(4, 0, SEEK_SET)                   = 0
write(4, "b0VIM 7.4\0\0\0\0\20\0\0\21%\357^\356&H\0\274\5\0\0mdug"..., 4096) = 4096
stat("/tmp/testFile", {st_mode=S_IFREG|0664, st_size=14, ...}) = 0
write(1, "\r\r\n\33[?1l\33>", 10)       = 10
write(1, "\33[?12l\33[?25h\33[?1049l", 20) = 20
close(4)                                = 0
unlink("/tmp/.testFile.swp")            = 0
brk(NULL)                               = 0x9e6000
brk(NULL)                               = 0x9e6000
brk(0x9d9000)                           = 0x9d9000
brk(NULL)                               = 0x9d9000
exit_group(0)                           = ?
+++ exited with 0 +++
```

### Exo 3 : Manipulation de droits

Pour chacune des commandes suivantes :

- expliquer à quoi elle sert

```shell
# Donne tout les droit a l'utilisateur (read, write, execute)
$ chmod 700 /tmp/testfile

# Même chose que le chmod 700 mais il fait le setuid aussi.
$ chmod 4700 /tmp/testfile

# quand on créer un fichier il prend dans ses parametre le nom de l'utilisateur ainsi que le groupe auquel il est affilié, cette commande permet de changer le nom de l'utilisateur (proprietaire)
$ chown root /tmp/testfile

# cette commande change le nom du groupe
$ chown root:root /tmp/testfile
```

- mettre en évidence les principaux syscalls

```shell
[mdugoua@localhost ~]$ strace -o /tmp/outputFile  chmod 700 /tmp/testFile

[mdugoua@localhost ~]$ cat /tmp/outputFile

# Recherche et ouverture des fichier necessaire a l'utilisation de c
execve("/usr/bin/chmod", ["chmod", "700", "/tmp/testFile"], 0x7ffc29f31530 /* 26 vars */) = 0
brk(NULL)                               = 0x1c65000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa074437000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fa074432000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fa073e49000
mprotect(0x7fa07400c000, 2097152, PROT_NONE) = 0
mmap(0x7fa07420c000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7fa07420c000
mmap(0x7fa074212000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fa074212000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa074431000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa07442f000
arch_prctl(ARCH_SET_FS, 0x7fa07442f740) = 0
mprotect(0x7fa07420c000, 16384, PROT_READ) = 0
mprotect(0x60c000, 4096, PROT_READ)     = 0
mprotect(0x7fa074438000, 4096, PROT_READ) = 0
munmap(0x7fa074432000, 18769)           = 0
brk(NULL)                               = 0x1c65000
brk(0x1c86000)                          = 0x1c86000
brk(NULL)                               = 0x1c86000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fa06d91f000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa074436000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7fa074436000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
umask(000)                              = 002
stat("/tmp/testFile", {st_mode=S_IFREG|0664, st_size=14, ...}) = 0
fchmodat(AT_FDCWD, "/tmp/testFile", 0700) = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

```shell
[mdugoua@localhost ~]$ strace -o /tmp/outputFile  chmod 4700 /tmp/testFile

[mdugoua@localhost ~]$ cat /tmp/outputFile

execve("/usr/bin/chmod", ["chmod", "4700", "/tmp/testFile"], 0x7ffd8e23ae70 /* 26 vars */) = 0
brk(NULL)                               = 0x1c09000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f417f7e0000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f417f7db000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f417f1f2000
mprotect(0x7f417f3b5000, 2097152, PROT_NONE) = 0
mmap(0x7f417f5b5000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7f417f5b5000
mmap(0x7f417f5bb000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f417f5bb000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f417f7da000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f417f7d8000
arch_prctl(ARCH_SET_FS, 0x7f417f7d8740) = 0
mprotect(0x7f417f5b5000, 16384, PROT_READ) = 0
mprotect(0x60c000, 4096, PROT_READ)     = 0
mprotect(0x7f417f7e1000, 4096, PROT_READ) = 0
munmap(0x7f417f7db000, 18769)           = 0
brk(NULL)                               = 0x1c09000
brk(0x1c2a000)                          = 0x1c2a000
brk(NULL)                               = 0x1c2a000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f4178cc8000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f417f7df000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f417f7df000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
umask(000)                              = 002
stat("/tmp/testFile", {st_mode=S_IFREG|0700, st_size=14, ...}) = 0
fchmodat(AT_FDCWD, "/tmp/testFile", 04700) = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

```shell
[mdugoua@localhost ~]$ sudo strace -o /tmp/outputFile  chown root /tmp/testFile
[sudo] password for mdugoua:

[mdugoua@localhost ~]$ cat /tmp/outputFile

execve("/bin/chown", ["chown", "root", "/tmp/testFile"], 0x7fffa4806e80 /* 18 vars */) = 0
brk(NULL)                               = 0x181a000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f765df30000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f765df2b000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f765d942000
mprotect(0x7f765db05000, 2097152, PROT_NONE) = 0
mmap(0x7f765dd05000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7f765dd05000
mmap(0x7f765dd0b000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f765dd0b000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f765df2a000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f765df28000
arch_prctl(ARCH_SET_FS, 0x7f765df28740) = 0
mprotect(0x7f765dd05000, 16384, PROT_READ) = 0
mprotect(0x60d000, 4096, PROT_READ)     = 0
mprotect(0x7f765df31000, 4096, PROT_READ) = 0
munmap(0x7f765df2b000, 18769)           = 0
brk(NULL)                               = 0x181a000
brk(0x183b000)                          = 0x183b000
brk(NULL)                               = 0x183b000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f7657418000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f765df2f000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f765df2f000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1949, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f765df2f000
read(3, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1949
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f765df2f000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f765df2b000
close(3)                                = 0
open("/lib64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=61624, ...}) = 0
mmap(NULL, 2173016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7657205000
mprotect(0x7f7657211000, 2093056, PROT_NONE) = 0
mmap(0x7f7657410000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xb000) = 0x7f7657410000
mmap(0x7f7657412000, 22616, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f7657412000
close(3)                                = 0
mprotect(0x7f7657410000, 4096, PROT_READ) = 0
munmap(0x7f765df2b000, 18769)           = 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=888, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f765df2f000
read(3, "root:x:0:0:root:/root:/bin/bash\n"..., 4096) = 888
close(3)                                = 0
munmap(0x7f765df2f000, 4096)            = 0
newfstatat(AT_FDCWD, "/tmp/testFile", {st_mode=S_IFREG|S_ISUID|0700, st_size=14, ...}, AT_SYMLINK_NOFOLLOW) = 0
fchownat(AT_FDCWD, "/tmp/testFile", 0, -1, 0) = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

```shell
[mdugoua@localhost ~]$ sudo strace -o /tmp/outputFile   chown root:root /tmp/testFile

[mdugoua@localhost ~]$ cat /tmp/outputFile

execve("/bin/chown", ["chown", "root:root", "/tmp/testFile"], 0x7ffc0929f340 /* 18 vars */) = 0
brk(NULL)                               = 0x24a2000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff43030d000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ff430308000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff42fd1f000
mprotect(0x7ff42fee2000, 2097152, PROT_NONE) = 0
mmap(0x7ff4300e2000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7ff4300e2000
mmap(0x7ff4300e8000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff4300e8000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff430307000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff430305000
arch_prctl(ARCH_SET_FS, 0x7ff430305740) = 0
mprotect(0x7ff4300e2000, 16384, PROT_READ) = 0
mprotect(0x60d000, 4096, PROT_READ)     = 0
mprotect(0x7ff43030e000, 4096, PROT_READ) = 0
munmap(0x7ff430308000, 18769)           = 0
brk(NULL)                               = 0x24a2000
brk(0x24c3000)                          = 0x24c3000
brk(NULL)                               = 0x24c3000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ff4297f5000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff43030c000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7ff43030c000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1949, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff43030c000
read(3, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1949
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7ff43030c000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ff430308000
close(3)                                = 0
open("/lib64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=61624, ...}) = 0
mmap(NULL, 2173016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff4295e2000
mprotect(0x7ff4295ee000, 2093056, PROT_NONE) = 0
mmap(0x7ff4297ed000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xb000) = 0x7ff4297ed000
mmap(0x7ff4297ef000, 22616, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff4297ef000
close(3)                                = 0
mprotect(0x7ff4297ed000, 4096, PROT_READ) = 0
munmap(0x7ff430308000, 18769)           = 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=888, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff43030c000
read(3, "root:x:0:0:root:/root:/bin/bash\n"..., 4096) = 888
close(3)                                = 0
munmap(0x7ff43030c000, 4096)            = 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/group", O_RDONLY|O_CLOEXEC)  = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=479, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff43030c000
read(3, "root:x:0:\nbin:x:1:\ndaemon:x:2:\ns"..., 4096) = 479
close(3)                                = 0
munmap(0x7ff43030c000, 4096)            = 0
newfstatat(AT_FDCWD, "/tmp/testFile", {st_mode=S_IFREG|0700, st_size=14, ...}, AT_SYMLINK_NOFOLLOW) = 0
fchownat(AT_FDCWD, "/tmp/testFile", 0, 0, 0) = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

### Exo 4 : `ping`

Mettre en évidence les principaux syscalls lors de :

```shell
$ ping 8.8.8.8

$ ping www.cnrtl.fr # c'est juste un nom de domaine random que je suis à peu près sûr que vous avez jamais résolu avec votre VM

```

```shell
[mdugoua@localhost ~]$ sudo strace -o /tmp/outputFile ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=63 time=17.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=63 time=16.4 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=63 time=25.9 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=63 time=17.9 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=63 time=23.9 ms
64 bytes from 8.8.8.8: icmp_seq=6 ttl=63 time=23.8 ms
^C
--- 8.8.8.8 ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5011ms
rtt min/avg/max/mdev = 16.473/20.931/25.951/3.742 ms
```

```shell
[mdugoua@localhost ~]$ cat /tmp/outputFile

execve("/bin/ping", ["ping", "8.8.8.8"], 0x7ffe2d1a16d8 /* 18 vars */) = 0
brk(NULL)                               = 0x562d9b64e000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e78000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f28b4e73000
close(3)                                = 0
open("/lib64/libcap.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\26\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=20048, ...}) = 0
mmap(NULL, 2114112, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b4a53000
mprotect(0x7f28b4a57000, 2093056, PROT_NONE) = 0
mmap(0x7f28b4c56000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f28b4c56000
close(3)                                = 0
open("/lib64/libidn.so.11", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0000\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=208920, ...}) = 0
mmap(NULL, 2302416, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b4820000
mprotect(0x7f28b4852000, 2093056, PROT_NONE) = 0
mmap(0x7f28b4a51000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x31000) = 0x7f28b4a51000
close(3)                                = 0
open("/lib64/libcrypto.so.10", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\321\6\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2521144, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e72000
mmap(NULL, 4596552, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b43bd000
mprotect(0x7f28b45f3000, 2097152, PROT_NONE) = 0
mmap(0x7f28b47f3000, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x236000) = 0x7f28b47f3000
mmap(0x7f28b481c000, 13128, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f28b481c000
close(3)                                = 0
open("/lib64/libresolv.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\3608\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=105824, ...}) = 0
mmap(NULL, 2198016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b41a4000
mprotect(0x7f28b41ba000, 2093056, PROT_NONE) = 0
mmap(0x7f28b43b9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15000) = 0x7f28b43b9000
mmap(0x7f28b43bb000, 6656, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f28b43bb000
close(3)                                = 0
open("/lib64/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20S\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1137024, ...}) = 0
mmap(NULL, 3150120, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b3ea2000
mprotect(0x7f28b3fa3000, 2093056, PROT_NONE) = 0
mmap(0x7f28b41a2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x100000) = 0x7f28b41a2000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e71000
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b3ad4000
mprotect(0x7f28b3c97000, 2097152, PROT_NONE) = 0
mmap(0x7f28b3e97000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7f28b3e97000
mmap(0x7f28b3e9d000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f28b3e9d000
close(3)                                = 0
open("/lib64/libattr.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\23\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19896, ...}) = 0
mmap(NULL, 2113904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b38cf000
mprotect(0x7f28b38d3000, 2093056, PROT_NONE) = 0
mmap(0x7f28b3ad2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f28b3ad2000
close(3)                                = 0
open("/lib64/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220\r\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19288, ...}) = 0
mmap(NULL, 2109712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b36cb000
mprotect(0x7f28b36cd000, 2097152, PROT_NONE) = 0
mmap(0x7f28b38cd000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f28b38cd000
close(3)                                = 0
open("/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=90248, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e70000
mmap(NULL, 2183272, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f28b34b5000
mprotect(0x7f28b34ca000, 2093056, PROT_NONE) = 0
mmap(0x7f28b36c9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x7f28b36c9000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e6f000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e6d000
arch_prctl(ARCH_SET_FS, 0x7f28b4e6d740) = 0
mprotect(0x7f28b3e97000, 16384, PROT_READ) = 0
mprotect(0x7f28b36c9000, 4096, PROT_READ) = 0
mprotect(0x7f28b38cd000, 4096, PROT_READ) = 0
mprotect(0x7f28b3ad2000, 4096, PROT_READ) = 0
mprotect(0x7f28b41a2000, 4096, PROT_READ) = 0
mprotect(0x7f28b43b9000, 4096, PROT_READ) = 0
mprotect(0x7f28b47f3000, 114688, PROT_READ) = 0
mprotect(0x7f28b4a51000, 4096, PROT_READ) = 0
mprotect(0x7f28b4c56000, 4096, PROT_READ) = 0
mprotect(0x562d99fe1000, 4096, PROT_READ) = 0
mprotect(0x7f28b4e79000, 4096, PROT_READ) = 0
munmap(0x7f28b4e73000, 18769)           = 0
brk(NULL)                               = 0x562d9b64e000
brk(0x562d9b66f000)                     = 0x562d9b66f000
open("/etc/pki/tls/legacy-settings", O_RDONLY) = -1 ENOENT (No such file or directory)
access("/etc/system-fips", F_OK)        = -1 ENOENT (No such file or directory)
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=1<<CAP_CHOWN|1<<CAP_DAC_OVERRIDE|1<<CAP_DAC_READ_SEARCH|1<<CAP_FOWNER|1<<CAP_FSETID|1<<CAP_KILL|1<<CAP_SETGID|1<<CAP_SETUID|1<<CAP_SETPCAP|1<<CAP_LINUX_IMMUTABLE|1<<CAP_NET_BIND_SERVICE|1<<CAP_NET_BROADCAST|1<<CAP_NET_ADMIN|1<<CAP_NET_RAW|1<<CAP_IPC_LOCK|1<<CAP_IPC_OWNER|1<<CAP_SYS_MODULE|1<<CAP_SYS_RAWIO|1<<CAP_SYS_CHROOT|1<<CAP_SYS_PTRACE|1<<CAP_SYS_PACCT|1<<CAP_SYS_ADMIN|1<<CAP_SYS_BOOT|1<<CAP_SYS_NICE|1<<CAP_SYS_RESOURCE|1<<CAP_SYS_TIME|1<<CAP_SYS_TTY_CONFIG|1<<CAP_MKNOD|1<<CAP_LEASE|1<<CAP_AUDIT_WRITE|1<<CAP_AUDIT_CONTROL|1<<CAP_SETFCAP|1<<CAP_MAC_OVERRIDE|1<<CAP_MAC_ADMIN|1<<CAP_SYSLOG|1<<CAP_WAKE_ALARM|1<<CAP_BLOCK_SUSPEND, permitted=1<<CAP_CHOWN|1<<CAP_DAC_OVERRIDE|1<<CAP_DAC_READ_SEARCH|1<<CAP_FOWNER|1<<CAP_FSETID|1<<CAP_KILL|1<<CAP_SETGID|1<<CAP_SETUID|1<<CAP_SETPCAP|1<<CAP_LINUX_IMMUTABLE|1<<CAP_NET_BIND_SERVICE|1<<CAP_NET_BROADCAST|1<<CAP_NET_ADMIN|1<<CAP_NET_RAW|1<<CAP_IPC_LOCK|1<<CAP_IPC_OWNER|1<<CAP_SYS_MODULE|1<<CAP_SYS_RAWIO|1<<CAP_SYS_CHROOT|1<<CAP_SYS_PTRACE|1<<CAP_SYS_PACCT|1<<CAP_SYS_ADMIN|1<<CAP_SYS_BOOT|1<<CAP_SYS_NICE|1<<CAP_SYS_RESOURCE|1<<CAP_SYS_TIME|1<<CAP_SYS_TTY_CONFIG|1<<CAP_MKNOD|1<<CAP_LEASE|1<<CAP_AUDIT_WRITE|1<<CAP_AUDIT_CONTROL|1<<CAP_SETFCAP|1<<CAP_MAC_OVERRIDE|1<<CAP_MAC_ADMIN|1<<CAP_SYSLOG|1<<CAP_WAKE_ALARM|1<<CAP_BLOCK_SUSPEND, inheritable=0}) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capset({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=0, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
prctl(PR_SET_KEEPCAPS, 1)               = 0
getuid()                                = 0
setuid(0)                               = 0
prctl(PR_SET_KEEPCAPS, 0)               = 0
getuid()                                = 0
geteuid()                               = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f28acf8b000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e77000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f28b4e77000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=0, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
capset({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=1<<CAP_NET_RAW, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP) = -1 EACCES (Permission denied)
socket(AF_INET, SOCK_RAW, IPPROTO_ICMP) = 3
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=1<<CAP_NET_RAW, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
capset({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=0, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 4
connect(4, {sa_family=AF_INET, sin_port=htons(1025), sin_addr=inet_addr("8.8.8.8")}, 16) = 0
getsockname(4, {sa_family=AF_INET, sin_port=htons(57547), sin_addr=inet_addr("10.0.2.15")}, [16]) = 0
close(4)                                = 0
setsockopt(3, SOL_RAW, ICMP_FILTER, ~(1<<ICMP_ECHOREPLY|1<<ICMP_DEST_UNREACH|1<<ICMP_SOURCE_QUENCH|1<<ICMP_REDIRECT|1<<ICMP_TIME_EXCEEDED|1<<ICMP_PARAMETERPROB), 4) = 0
setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
setsockopt(3, SOL_SOCKET, SO_SNDBUF, [324], 4) = 0
setsockopt(3, SOL_SOCKET, SO_RCVBUF, [65536], 4) = 0
getsockopt(3, SOL_SOCKET, SO_RCVBUF, [131072], [4]) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f28b4e77000
write(1, "PING 8.8.8.8 (8.8.8.8) 56(84) by"..., 45) = 45
setsockopt(3, SOL_SOCKET, SO_TIMESTAMP, [1], 4) = 0
setsockopt(3, SOL_SOCKET, SO_SNDTIMEO, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
setsockopt(3, SOL_SOCKET, SO_RCVTIMEO, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
getpid()                                = 9224
rt_sigaction(SIGINT, {sa_handler=0x562d99dd8dd0, sa_mask=[], sa_flags=SA_RESTORER|SA_INTERRUPT, sa_restorer=0x7f28b3b0a3b0}, NULL, 8) = 0
rt_sigaction(SIGALRM, {sa_handler=0x562d99dd8dd0, sa_mask=[], sa_flags=SA_RESTORER|SA_INTERRUPT, sa_restorer=0x7f28b3b0a3b0}, NULL, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=0x562d99dd8dc0, sa_mask=[], sa_flags=SA_RESTORER|SA_INTERRUPT, sa_restorer=0x7f28b3b0a3b0}, NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCGWINSZ, {ws_row=59, ws_col=112, ws_xpixel=0, ws_ypixel=0}) = 0
sendto(3, "\10\0_\\$\10\0\1=.\357^\0\0\0\0\205:\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \27@\0?\1\377s\10\10\10\10\n\0\2\17\0\0g\\$\10\0\1=.\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733245, tv_usec=294523}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from 8.8.8.8: icmp_seq="..., 54) = 54
poll([{fd=3, events=POLLIN|POLLERR}], 1, 982) = 0 (Timeout)
sendto(3, "\10\0\25P$\10\0\2>.\357^\0\0\0\0\316E\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \30@\0?\1\377r\10\10\10\10\n\0\2\17\0\0\35P$\10\0\2>.\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733246, tv_usec=296487}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from 8.8.8.8: icmp_seq="..., 54) = 54
poll([{fd=3, events=POLLIN|POLLERR}], 1, 984) = 0 (Timeout)
sendto(3, "\10\0jJ$\10\0\3?.\357^\0\0\0\0xJ\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \31@\0?\1\377q\10\10\10\10\n\0\2\17\0\0rJ$\10\0\3?.\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733247, tv_usec=307159}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from 8.8.8.8: icmp_seq="..., 54) = 54
poll([{fd=3, events=POLLIN|POLLERR}], 1, 974) = 0 (Timeout)
sendto(3, "\10\0\22=$\10\0\4@.\357^\0\0\0\0\317V\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \32@\0?\1\377p\10\10\10\10\n\0\2\17\0\0\32=$\10\0\4@.\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733248, tv_usec=302342}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from 8.8.8.8: icmp_seq="..., 54) = 54
poll([{fd=3, events=POLLIN|POLLERR}], 1, 982) = 0 (Timeout)
sendto(3, "\10\0u3$\10\0\5A.\357^\0\0\0\0k_\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \33@\0?\1\377o\10\10\10\10\n\0\2\17\0\0}3$\10\0\5A.\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733249, tv_usec=310515}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from 8.8.8.8: icmp_seq="..., 54) = 54
poll([{fd=3, events=POLLIN|POLLERR}], 1, 976) = 0 (Timeout)
sendto(3, "\10\0+*$\10\0\6B.\357^\0\0\0\0\264g\4\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("8.8.8.8")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \34@\0?\1\377n\10\10\10\10\n\0\2\17\0\0003*$\10\0\6B.\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733250, tv_usec=312541}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from 8.8.8.8: icmp_seq="..., 54) = 54
poll([{fd=3, events=POLLIN|POLLERR}], 1, 976) = ? ERESTART_RESTARTBLOCK (Interrupted by signal)
--- SIGINT {si_signo=SIGINT, si_code=SI_KERNEL} ---
rt_sigreturn({mask=[]})                 = -1 EINTR (Interrupted system call)
write(1, "\n", 1)                       = 1
write(1, "--- 8.8.8.8 ping statistics ---\n", 32) = 32
write(1, "6 packets transmitted, 6 receive"..., 63) = 63
write(1, "rtt min/avg/max/mdev = 16.473/20"..., 53) = 53
exit_group(0)                           = ?
+++ exited with 0 +++
```



```shell
[mdugoua@localhost ~]$ sudo strace -o /tmp/outputFile ping www.cnrtl.fr
[sudo] password for mdugoua:
PING www.cnrtl.fr (194.214.124.226) 56(84) bytes of data.
64 bytes from www.cnrtl.fr (194.214.124.226): icmp_seq=1 ttl=63 time=21.0 ms
64 bytes from www.cnrtl.fr (194.214.124.226): icmp_seq=2 ttl=63 time=29.8 ms
64 bytes from www.cnrtl.fr (194.214.124.226): icmp_seq=3 ttl=63 time=29.4 ms
^C
--- www.cnrtl.fr ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2006ms
rtt min/avg/max/mdev = 21.091/26.788/29.835/4.031 ms
```

```shell
[mdugoua@localhost ~]$ cat /tmp/outputFile

execve("/bin/ping", ["ping", "www.cnrtl.fr"], 0x7ffdb8a82ac8 /* 18 vars */) = 0
brk(NULL)                               = 0x564d462fc000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647e000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f47e6479000
close(3)                                = 0
open("/lib64/libcap.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\26\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=20048, ...}) = 0
mmap(NULL, 2114112, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e6059000
mprotect(0x7f47e605d000, 2093056, PROT_NONE) = 0
mmap(0x7f47e625c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f47e625c000
close(3)                                = 0
open("/lib64/libidn.so.11", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0000\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=208920, ...}) = 0
mmap(NULL, 2302416, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e5e26000
mprotect(0x7f47e5e58000, 2093056, PROT_NONE) = 0
mmap(0x7f47e6057000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x31000) = 0x7f47e6057000
close(3)                                = 0
open("/lib64/libcrypto.so.10", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\321\6\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2521144, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e6478000
mmap(NULL, 4596552, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e59c3000
mprotect(0x7f47e5bf9000, 2097152, PROT_NONE) = 0
mmap(0x7f47e5df9000, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x236000) = 0x7f47e5df9000
mmap(0x7f47e5e22000, 13128, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f47e5e22000
close(3)                                = 0
open("/lib64/libresolv.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\3608\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=105824, ...}) = 0
mmap(NULL, 2198016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e57aa000
mprotect(0x7f47e57c0000, 2093056, PROT_NONE) = 0
mmap(0x7f47e59bf000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15000) = 0x7f47e59bf000
mmap(0x7f47e59c1000, 6656, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f47e59c1000
close(3)                                = 0
open("/lib64/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20S\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1137024, ...}) = 0
mmap(NULL, 3150120, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e54a8000
mprotect(0x7f47e55a9000, 2093056, PROT_NONE) = 0
mmap(0x7f47e57a8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x100000) = 0x7f47e57a8000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20&\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2156160, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e6477000
mmap(NULL, 3985888, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e50da000
mprotect(0x7f47e529d000, 2097152, PROT_NONE) = 0
mmap(0x7f47e549d000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c3000) = 0x7f47e549d000
mmap(0x7f47e54a3000, 16864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f47e54a3000
close(3)                                = 0
open("/lib64/libattr.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\23\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19896, ...}) = 0
mmap(NULL, 2113904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e4ed5000
mprotect(0x7f47e4ed9000, 2093056, PROT_NONE) = 0
mmap(0x7f47e50d8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f47e50d8000
close(3)                                = 0
open("/lib64/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220\r\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19288, ...}) = 0
mmap(NULL, 2109712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e4cd1000
mprotect(0x7f47e4cd3000, 2097152, PROT_NONE) = 0
mmap(0x7f47e4ed3000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f47e4ed3000
close(3)                                = 0
open("/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20!\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=90248, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e6476000
mmap(NULL, 2183272, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f47e4abb000
mprotect(0x7f47e4ad0000, 2093056, PROT_NONE) = 0
mmap(0x7f47e4ccf000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x7f47e4ccf000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e6475000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e6473000
arch_prctl(ARCH_SET_FS, 0x7f47e6473740) = 0
mprotect(0x7f47e549d000, 16384, PROT_READ) = 0
mprotect(0x7f47e4ccf000, 4096, PROT_READ) = 0
mprotect(0x7f47e4ed3000, 4096, PROT_READ) = 0
mprotect(0x7f47e50d8000, 4096, PROT_READ) = 0
mprotect(0x7f47e57a8000, 4096, PROT_READ) = 0
mprotect(0x7f47e59bf000, 4096, PROT_READ) = 0
mprotect(0x7f47e5df9000, 114688, PROT_READ) = 0
mprotect(0x7f47e6057000, 4096, PROT_READ) = 0
mprotect(0x7f47e625c000, 4096, PROT_READ) = 0
mprotect(0x564d44989000, 4096, PROT_READ) = 0
mprotect(0x7f47e647f000, 4096, PROT_READ) = 0
munmap(0x7f47e6479000, 18769)           = 0
brk(NULL)                               = 0x564d462fc000
brk(0x564d4631d000)                     = 0x564d4631d000
open("/etc/pki/tls/legacy-settings", O_RDONLY) = -1 ENOENT (No such file or directory)
access("/etc/system-fips", F_OK)        = -1 ENOENT (No such file or directory)
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=1<<CAP_CHOWN|1<<CAP_DAC_OVERRIDE|1<<CAP_DAC_READ_SEARCH|1<<CAP_FOWNER|1<<CAP_FSETID|1<<CAP_KILL|1<<CAP_SETGID|1<<CAP_SETUID|1<<CAP_SETPCAP|1<<CAP_LINUX_IMMUTABLE|1<<CAP_NET_BIND_SERVICE|1<<CAP_NET_BROADCAST|1<<CAP_NET_ADMIN|1<<CAP_NET_RAW|1<<CAP_IPC_LOCK|1<<CAP_IPC_OWNER|1<<CAP_SYS_MODULE|1<<CAP_SYS_RAWIO|1<<CAP_SYS_CHROOT|1<<CAP_SYS_PTRACE|1<<CAP_SYS_PACCT|1<<CAP_SYS_ADMIN|1<<CAP_SYS_BOOT|1<<CAP_SYS_NICE|1<<CAP_SYS_RESOURCE|1<<CAP_SYS_TIME|1<<CAP_SYS_TTY_CONFIG|1<<CAP_MKNOD|1<<CAP_LEASE|1<<CAP_AUDIT_WRITE|1<<CAP_AUDIT_CONTROL|1<<CAP_SETFCAP|1<<CAP_MAC_OVERRIDE|1<<CAP_MAC_ADMIN|1<<CAP_SYSLOG|1<<CAP_WAKE_ALARM|1<<CAP_BLOCK_SUSPEND, permitted=1<<CAP_CHOWN|1<<CAP_DAC_OVERRIDE|1<<CAP_DAC_READ_SEARCH|1<<CAP_FOWNER|1<<CAP_FSETID|1<<CAP_KILL|1<<CAP_SETGID|1<<CAP_SETUID|1<<CAP_SETPCAP|1<<CAP_LINUX_IMMUTABLE|1<<CAP_NET_BIND_SERVICE|1<<CAP_NET_BROADCAST|1<<CAP_NET_ADMIN|1<<CAP_NET_RAW|1<<CAP_IPC_LOCK|1<<CAP_IPC_OWNER|1<<CAP_SYS_MODULE|1<<CAP_SYS_RAWIO|1<<CAP_SYS_CHROOT|1<<CAP_SYS_PTRACE|1<<CAP_SYS_PACCT|1<<CAP_SYS_ADMIN|1<<CAP_SYS_BOOT|1<<CAP_SYS_NICE|1<<CAP_SYS_RESOURCE|1<<CAP_SYS_TIME|1<<CAP_SYS_TTY_CONFIG|1<<CAP_MKNOD|1<<CAP_LEASE|1<<CAP_AUDIT_WRITE|1<<CAP_AUDIT_CONTROL|1<<CAP_SETFCAP|1<<CAP_MAC_OVERRIDE|1<<CAP_MAC_ADMIN|1<<CAP_SYSLOG|1<<CAP_WAKE_ALARM|1<<CAP_BLOCK_SUSPEND, inheritable=0}) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capset({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=0, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
prctl(PR_SET_KEEPCAPS, 1)               = 0
getuid()                                = 0
setuid(0)                               = 0
prctl(PR_SET_KEEPCAPS, 0)               = 0
getuid()                                = 0
geteuid()                               = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=106075056, ...}) = 0
mmap(NULL, 106075056, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f47de591000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2502, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647d000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2502
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f47e647d000, 4096)            = 0
open("/usr/lib/locale/UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=0, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
capset({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=1<<CAP_NET_RAW, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP) = -1 EACCES (Permission denied)
socket(AF_INET, SOCK_RAW, IPPROTO_ICMP) = 3
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, NULL) = 0
capget({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=1<<CAP_NET_RAW, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
capset({version=_LINUX_CAPABILITY_VERSION_3, pid=0}, {effective=0, permitted=1<<CAP_NET_ADMIN|1<<CAP_NET_RAW, inheritable=0}) = 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 4
connect(4, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 4
connect(4, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=1949, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647d000
read(4, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1949
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7f47e647d000, 4096)            = 0
stat("/etc/resolv.conf", {st_mode=S_IFREG|0644, st_size=92, ...}) = 0
open("/etc/host.conf", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=9, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647d000
read(4, "multi on\n", 4096)             = 9
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7f47e647d000, 4096)            = 0
open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=92, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647d000
read(4, "# Generated by NetworkManager\nse"..., 4096) = 92
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7f47e647d000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 4, 0) = 0x7f47e6479000
close(4)                                = 0
open("/lib64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000!\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=61624, ...}) = 0
mmap(NULL, 2173016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f47de37e000
mprotect(0x7f47de38a000, 2093056, PROT_NONE) = 0
mmap(0x7f47de589000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0xb000) = 0x7f47de589000
mmap(0x7f47de58b000, 22616, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f47de58b000
close(4)                                = 0
mprotect(0x7f47de589000, 4096, PROT_READ) = 0
munmap(0x7f47e6479000, 18769)           = 0
open("/etc/hosts", O_RDONLY|O_CLOEXEC)  = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=158, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647d000
read(4, "127.0.0.1   localhost localhost."..., 4096) = 158
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7f47e647d000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=18769, ...}) = 0
mmap(NULL, 18769, PROT_READ, MAP_PRIVATE, 4, 0) = 0x7f47e6479000
close(4)                                = 0
open("/lib64/libnss_dns.so.2", O_RDONLY|O_CLOEXEC) = 4
read(4, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \20\0\0\0\0\0\0"..., 832) = 832
fstat(4, {st_mode=S_IFREG|0755, st_size=31408, ...}) = 0
mmap(NULL, 2121952, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0x7f47de177000
mprotect(0x7f47de17d000, 2093056, PROT_NONE) = 0
mmap(0x7f47de37c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x5000) = 0x7f47de37c000
close(4)                                = 0
mprotect(0x7f47de37c000, 4096, PROT_READ) = 0
munmap(0x7f47e6479000, 18769)           = 0
socket(AF_INET, SOCK_DGRAM|SOCK_CLOEXEC|SOCK_NONBLOCK, IPPROTO_IP) = 4
connect(4, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("89.2.0.1")}, 16) = 0
poll([{fd=4, events=POLLOUT}], 1, 0)    = 1 ([{fd=4, revents=POLLOUT}])
sendto(4, "\210\223\1\0\0\1\0\0\0\0\0\0\3www\5cnrtl\2fr\0\0\1\0\1", 30, MSG_NOSIGNAL, NULL, 0) = 30
poll([{fd=4, events=POLLIN}], 1, 5000)  = 1 ([{fd=4, revents=POLLIN}])
ioctl(4, FIONREAD, [46])                = 0
recvfrom(4, "\210\223\201\200\0\1\0\1\0\0\0\0\3www\5cnrtl\2fr\0\0\1\0\1\300\f"..., 1024, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("89.2.0.1")}, [28->16]) = 46
close(4)                                = 0
socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 4
connect(4, {sa_family=AF_INET, sin_port=htons(1025), sin_addr=inet_addr("194.214.124.226")}, 16) = 0
getsockname(4, {sa_family=AF_INET, sin_port=htons(35397), sin_addr=inet_addr("10.0.2.15")}, [16]) = 0
close(4)                                = 0
setsockopt(3, SOL_RAW, ICMP_FILTER, ~(1<<ICMP_ECHOREPLY|1<<ICMP_DEST_UNREACH|1<<ICMP_SOURCE_QUENCH|1<<ICMP_REDIRECT|1<<ICMP_TIME_EXCEEDED|1<<ICMP_PARAMETERPROB), 4) = 0
setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
setsockopt(3, SOL_SOCKET, SO_SNDBUF, [324], 4) = 0
setsockopt(3, SOL_SOCKET, SO_RCVBUF, [65536], 4) = 0
getsockopt(3, SOL_SOCKET, SO_RCVBUF, [131072], [4]) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647d000
write(1, "PING www.cnrtl.fr (194.214.124.2"..., 58) = 58
setsockopt(3, SOL_SOCKET, SO_TIMESTAMP, [1], 4) = 0
setsockopt(3, SOL_SOCKET, SO_SNDTIMEO, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
setsockopt(3, SOL_SOCKET, SO_RCVTIMEO, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
getpid()                                = 9270
rt_sigaction(SIGINT, {sa_handler=0x564d44780dd0, sa_mask=[], sa_flags=SA_RESTORER|SA_INTERRUPT, sa_restorer=0x7f47e51103b0}, NULL, 8) = 0
rt_sigaction(SIGALRM, {sa_handler=0x564d44780dd0, sa_mask=[], sa_flags=SA_RESTORER|SA_INTERRUPT, sa_restorer=0x7f47e51103b0}, NULL, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=0x564d44780dc0, sa_mask=[], sa_flags=SA_RESTORER|SA_INTERRUPT, sa_restorer=0x7f47e51103b0}, NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCGWINSZ, {ws_row=59, ws_col=112, ws_xpixel=0, ws_ypixel=0}) = 0
sendto(3, "\10\0\247\370$6\0\1$0\357^\0\0\0\0Wn\2\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("194.214.124.226")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("194.214.124.226")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T \36@\0?\1\317\303\302\326|\342\n\0\2\17\0\0\257\370$6\0\1$0\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733732, tv_usec=180410}}], msg_controllen=32, msg_flags=0}, 0) = 84
stat("/etc/resolv.conf", {st_mode=S_IFREG|0644, st_size=92, ...}) = 0
open("/etc/hosts", O_RDONLY|O_CLOEXEC)  = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=158, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f47e647c000
read(4, "127.0.0.1   localhost localhost."..., 4096) = 158
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x7f47e647c000, 4096)            = 0
socket(AF_INET, SOCK_DGRAM|SOCK_CLOEXEC|SOCK_NONBLOCK, IPPROTO_IP) = 4
connect(4, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("89.2.0.1")}, 16) = 0
poll([{fd=4, events=POLLOUT}], 1, 0)    = 1 ([{fd=4, revents=POLLOUT}])
sendto(4, "\254\363\1\0\0\1\0\0\0\0\0\0\003226\003124\003214\003194\7in-"..., 46, MSG_NOSIGNAL, NULL, 0) = 46
poll([{fd=4, events=POLLIN}], 1, 5000)  = 1 ([{fd=4, revents=POLLIN}])
ioctl(4, FIONREAD, [98])                = 0
recvfrom(4, "\254\363\201\200\0\1\0\2\0\0\0\0\003226\003124\003214\003194\7in-"..., 1024, 0, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("89.2.0.1")}, [28->16]) = 98
close(4)                                = 0
write(1, "64 bytes from www.cnrtl.fr (194."..., 77) = 77
poll([{fd=3, events=POLLIN|POLLERR}], 1, 810) = 0 (Timeout)
sendto(3, "\10\0002\352$6\0\2%0\357^\0\0\0\0\313{\2\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("194.214.124.226")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("194.214.124.226")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T  @\0?\1\317\301\302\326|\342\n\0\2\17\0\0:\352$6\0\2%0\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733733, tv_usec=192598}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from www.cnrtl.fr (194."..., 77) = 77
poll([{fd=3, events=POLLIN|POLLERR}], 1, 970) = 0 (Timeout)
sendto(3, "\10\0\317\337$6\0\3&0\357^\0\0\0\0-\205\2\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("194.214.124.226")}, 16) = 64
recvmsg(3, {msg_name={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("194.214.124.226")}, msg_namelen=128->16, msg_iov=[{iov_base="E\0\0T !@\0?\1\317\300\302\326|\342\n\0\2\17\0\0\327\337$6\0\3&0\357^"..., iov_len=192}], msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SCM_TIMESTAMP, cmsg_data={tv_sec=1592733734, tv_usec=194603}}], msg_controllen=32, msg_flags=0}, 0) = 84
write(1, "64 bytes from www.cnrtl.fr (194."..., 77) = 77
poll([{fd=3, events=POLLIN|POLLERR}], 1, 971) = ? ERESTART_RESTARTBLOCK (Interrupted by signal)
--- SIGINT {si_signo=SIGINT, si_code=SI_KERNEL} ---
rt_sigreturn({mask=[]})                 = -1 EINTR (Interrupted system call)
write(1, "\n", 1)                       = 1
write(1, "--- www.cnrtl.fr ping statistics"..., 37) = 37
write(1, "3 packets transmitted, 3 receive"..., 63) = 63
write(1, "rtt min/avg/max/mdev = 21.091/26"..., 53) = 53
exit_group(0)                           = ?
+++ exited with 0 +++
```