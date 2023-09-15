# Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [v0.5.0](https://github.com/divnix/hive/compare/aa529b4d87776036bf92e98c23c3a0c4de5e12d6..v0.5.0) - 2023-09-15
#### Bug Fixes
- **(bee-module)** fix wsl inputs description - ([ab85a68](https://github.com/divnix/hive/commit/ab85a68eea36e79de4ad0bc53919a9c7e5e98678)) - Andrii Panasiuk
- **(blaggacao)** my beloved j command - ([2599982](https://github.com/divnix/hive/commit/259998203048728ca3b2caa4ca55fdf31ba2506e)) - David Arnold
- **(blaggacao)** use nixGL for proper OpenGL rendering outside of nixos - ([6444e6e](https://github.com/divnix/hive/commit/6444e6e89f7f826602ad46f1f5d26a4dcb4e7401)) - David Arnold
- **(blaggacao)** j function - ([7deef59](https://github.com/divnix/hive/commit/7deef598b3d875d94a07dd3a32449654210de512)) - David Arnold
- **(blaggacao)** more hm fixes; including upstreamable - ([e3b670d](https://github.com/divnix/hive/commit/e3b670de22a24bcb9b92b8f1c20883fc0e4bd438)) - David Arnold
- **(darwinConfigurations)** add inputs to actions - ([56c00ff](https://github.com/divnix/hive/commit/56c00ff670501b5021d7229b3707de911fdb62e5)) - Andrii Panasiuk
- use __cr and actually call baseNameOf - ([51ebd70](https://github.com/divnix/hive/commit/51ebd702e98a03151352f1ecc41036c985b8c58e)) - Lord-Valen
- disko configuration typo; rm unused code - ([9aa6e9c](https://github.com/divnix/hive/commit/9aa6e9c6b2481c780ae999487d394a3b456730f1)) - David Arnold
- oversight in colmena collector refactoring - ([d5d5ee5](https://github.com/divnix/hive/commit/d5d5ee55cdddbb85eb4b6fd3e158c2f01f7f983a)) - David Arnold
- transformers darwinConfigurations - ([2a75ef2](https://github.com/divnix/hive/commit/2a75ef2f84eb433d257f7569c58a1814f3c03137)) - hoppla20
- use haumea v0.20.0 - ([859b199](https://github.com/divnix/hive/commit/859b199fea9240ab5620cbb8ba2687090bec3353)) - David Arnold
- colmena collector - ([107fdd4](https://github.com/divnix/hive/commit/107fdd47186e1458492fef1e627665667a7305f2)) - David Arnold
- pass asserted config incl options to check isDefined - ([b3d6aa0](https://github.com/divnix/hive/commit/b3d6aa048f5931ad8df21724a72bd47daa991ed6)) - David Arnold
- add license - ([d185c33](https://github.com/divnix/hive/commit/d185c3350eee960ccdb2d8c3e14600f89ccf8447)) - David Arnold
- general pasteuriz instrumentation - ([75a1f84](https://github.com/divnix/hive/commit/75a1f846255f55c8c019e2cf3461a557be875c96)) - Lina Avendaño
- violently silence the wrong nixos-rebuild reflexes - ([822a06f](https://github.com/divnix/hive/commit/822a06f7a187109791468ab8f523cfddfefb6b8e)) - David Arnold
- badge links - ([2295360](https://github.com/divnix/hive/commit/2295360ef1392df23e26282833ddef21ab626d33)) - David Arnold
- patreurize - transfer the nixpkgs config into the module system - ([b5c3776](https://github.com/divnix/hive/commit/b5c377646fadef5177e359ed893b0a5dd8b6beb6)) - David Arnold
- disko slimer derivation - ([cf9d293](https://github.com/divnix/hive/commit/cf9d293239d8de5b07b47ba7979d136e5baa002a)) - David Arnold
- build-larva helper - ([0841bad](https://github.com/divnix/hive/commit/0841bad70c52bd2d22ec02788215ab4148740847)) - David Arnold
- build-larva helper - ([e4d5c9c](https://github.com/divnix/hive/commit/e4d5c9c441acbf4737c39d2d1a7e14a82f0042cc)) - David Arnold
- allow importaing nixos channel other than nixpkgs - ([98214c4](https://github.com/divnix/hive/commit/98214c4de44df954b4e3001771976a0285f5749c)) - David Arnold
- name space clashes - ([f532568](https://github.com/divnix/hive/commit/f532568755835426047a60ca215b764480b10e57)) - David Arnold
- .envrc with no rel-ref to main any more - ([644af08](https://github.com/divnix/hive/commit/644af08f19dd80c16e4e5b40a2da723362f6ee57)) - David Arnold
- make subshell independent for non-git envs (bootstrapping) - ([1fc77cf](https://github.com/divnix/hive/commit/1fc77cfadba73835881caed28dec3cf6da8ad85a)) - David Arnold
- larva iso - ([f41bcda](https://github.com/divnix/hive/commit/f41bcda0b0adc4100d20fd78889fed3088631c89)) - David Arnold
- enable alacritty again - ([345ab1c](https://github.com/divnix/hive/commit/345ab1cf6d250c63646f3f4096a14522b231c1cd)) - David Arnold
- nix version in bootstrapper - ([873ae18](https://github.com/divnix/hive/commit/873ae188f672feed16d690c9c57914cd396c2248)) - David Arnold
- local-larva - ([9b8c1fa](https://github.com/divnix/hive/commit/9b8c1fa81ee69a449368eea38b1d29c2ca83b5b6)) - David Arnold
- iso store content - ([1f15fbc](https://github.com/divnix/hive/commit/1f15fbcc21dbc425e0611311be3212e824f7959a)) - David Arnold
#### Documentation
- fix typo - ([004bc29](https://github.com/divnix/hive/commit/004bc2912e0fed2170167e938c023b6e753758e6)) - Lord-Valen
- clarify require input colmena use - ([cef2a89](https://github.com/divnix/hive/commit/cef2a897fdc950e86a5e28be9496e8ab70740124)) - David Arnold
#### Features
- **(_QUEEN)** use std nixago presets - ([d6b061f](https://github.com/divnix/hive/commit/d6b061f2fb6b3edc45fdb470b8232fc6732f4421)) - David Arnold
- **(bee-module)** add nixos-wsl integration - ([4fbfacf](https://github.com/divnix/hive/commit/4fbfacfdf6049d4a7491d9b3b78095fae47f1f75)) - Andrii Panasiuk
- **(lina2358)** configure ssh - ([8534802](https://github.com/divnix/hive/commit/8534802be4a099bb1d13c198c993e6b09150c3e1)) - Lina Avendaño
- **(lina2358)** add gitlab vscode extension - ([7685c88](https://github.com/divnix/hive/commit/7685c887a4080bbeffcf6d7b30f5262222d52178)) - Lina Avendaño
- **(lina2358)** add initial [working] configuration - ([347c284](https://github.com/divnix/hive/commit/347c284c126c1238f85a0331e373101a13fd2584)) - David Arnold
- add best practice local cell - ([fe85532](https://github.com/divnix/hive/commit/fe855329830d2656bbc6bedd154e7fc7a75ec35b)) - David Arnold
- add a convenience block target load finder - ([8de984b](https://github.com/divnix/hive/commit/8de984b0abd3401b39b5c357dc49a2e1fff49d19)) - David Arnold
- set default location on haumea loaded modules for deduplication - ([ad86414](https://github.com/divnix/hive/commit/ad8641456c1a39317451dc2773c64b9d6d53331e)) - David Arnold
- haumea-load all modules as noramlized module functions - ([c5c2c81](https://github.com/divnix/hive/commit/c5c2c819408b9f8936afd31d1cd1958b97c04a46)) - David Arnold
- split checks and transformers, make use of haumea folder structure - ([551626b](https://github.com/divnix/hive/commit/551626b8aa1ff5ee6d79db703b36006540cc085b)) - vincent.cui
- refactor repository to use haumea to load ./src - ([703f2cc](https://github.com/divnix/hive/commit/703f2cc543b707ecea4325b530bc555d0a04c37a)) - vincent.cui
- used haumea's scoped importers and freeze hive.load semantics - ([669cdfc](https://github.com/divnix/hive/commit/669cdfcf61823d33f11a4fe5ee1f3c34903f4eaa)) - David Arnold
- add haumea PR with hoistImports feature - ([4d75cf0](https://github.com/divnix/hive/commit/4d75cf04045cc403aead0fd6f4e96fbf1419e560)) - David Arnold
- add haumea compat wrapper for load function - ([79105e5](https://github.com/divnix/hive/commit/79105e5d405652ea07506461cf12c00a42841a86)) - David Arnold
- adopt haumea as (much better) rakeLeaves alternative - ([56472bd](https://github.com/divnix/hive/commit/56472bd697f0b163f525f09d56611e8783182401)) - David Arnold
- add darwin's cider - ([f412bca](https://github.com/divnix/hive/commit/f412bca98a5ed47578062494bb90754581df0a46)) - David Arnold
- make renamer configurable - ([6355b97](https://github.com/divnix/hive/commit/6355b9746709343291eb8ad1d7430560d867f749)) - David Arnold
- use numtide/nixpkgs-unfree - compatible paisano - ([fc952a5](https://github.com/divnix/hive/commit/fc952a5c7f37bf49f9f6f344f378ed4080d3518f)) - David Arnold
- add hm integration to nixos - ([1189ab7](https://github.com/divnix/hive/commit/1189ab7bb2dd2b6ea1351c7d5a1c83db39fc0690)) - David Arnold
- add disko soil - ([aae2ded](https://github.com/divnix/hive/commit/aae2dedb221549284a1fbd0da25cdbbb8f0620fe)) - David Arnold
- add badges - ([cad18a7](https://github.com/divnix/hive/commit/cad18a7980cbcf242b292ed02a12d00a7fdb7898)) - David Arnold
- violently silence the wrong nixos-rebuild reflexes - ([b9164de](https://github.com/divnix/hive/commit/b9164deaaf0490800bd795e23b83e7ee40613e11)) - David Arnold
- add nixos-hardware libaray - ([cb6b001](https://github.com/divnix/hive/commit/cb6b001261b98f31574e6268d13305fa3bb2459b)) - David Arnold
- prototype ifwifi performance for larva - ([e9e3980](https://github.com/divnix/hive/commit/e9e3980b5d3ff42c7b9d2d9147cd4220fe51688b)) - David Arnold
- add preview version of disko formatting - ([1328b09](https://github.com/divnix/hive/commit/1328b090860a372106dae7f6b1a3af92711920ce)) - David Arnold
- add writedisk utility to devshell - ([4214e52](https://github.com/divnix/hive/commit/4214e5220b05d930e66ecde869925b83413827b0)) - David Arnold
- hm support - ([928eaa4](https://github.com/divnix/hive/commit/928eaa403dc9dcb03f0ac884ed481b1510a02551)) - David Arnold
- update std input - ([25dc672](https://github.com/divnix/hive/commit/25dc6722b0177ecc315138fd5274a9849de02392)) - David Arnold
- add bootstrap-iso via nixos-generators - ([313c32d](https://github.com/divnix/hive/commit/313c32dc2d7ccdfb2142c0ab832bceab42bd195d)) - David Arnold
- update & optimize flake locks - ([d7119b1](https://github.com/divnix/hive/commit/d7119b1d5d1fd6f88c2d0c051c1512ff0edaa91f)) - David Arnold
- make-honey with colmena on the soil - ([e135503](https://github.com/divnix/hive/commit/e13550329b815d253a630762c949b7160ef449fb)) - David Arnold
#### Refactoring
- **(blaggacao)** update & organize hm profiles just a little - ([1de2aba](https://github.com/divnix/hive/commit/1de2abaad35a6699b8e686a43c214498f4d6734b)) - David Arnold
- **(lina2358)** simplify aaand disko! - ([b942986](https://github.com/divnix/hive/commit/b942986b03d4dd497f5405959c8f754800059b1e)) - David Arnold
- factorize colmena configurations further - ([295e8bd](https://github.com/divnix/hive/commit/295e8bd3498b04bc73b28d48dda0a0766833b3b5)) - David Arnold
- cleanup pasteurize & beeModule - ([9ca737f](https://github.com/divnix/hive/commit/9ca737f0c6797bb1921623c2a44d305a4d6182d1)) - David Arnold
- into a sister to Standard - ([8a33a60](https://github.com/divnix/hive/commit/8a33a6081f617248de9843eb2b0c1ea827fc60b9)) - David Arnold
- rm omega (currently not using hive); welcome back later - ([5c2fed7](https://github.com/divnix/hive/commit/5c2fed752c0b530a6edaab41587561e66d4f0f38)) - David Arnold
- remove unsupported hm version (and nixos) - ([b2c4b22](https://github.com/divnix/hive/commit/b2c4b22ba6deb6e3558a0ce19eebee3b99f11a45)) - David Arnold
- be a witchdoctor and end up on the pyre :-) - ([309f9bd](https://github.com/divnix/hive/commit/309f9bdc44b3b45c72e6cd4edc98765e5167d6e4)) - David Arnold
- cleanup; proper colmena input - ([8895f90](https://github.com/divnix/hive/commit/8895f90787a93cedebc9c1749052ede86045822b)) - David Arnold
- cleanup - ([2a48099](https://github.com/divnix/hive/commit/2a48099a2d1208bb49096e19e17ea3635a3ea066)) - David Arnold
- cleanup - ([41a68d2](https://github.com/divnix/hive/commit/41a68d23fa109d2b1c62d493fad4b33a3eec9808)) - David Arnold
- remove adrgen / docs - ([c57a118](https://github.com/divnix/hive/commit/c57a118dc56ceaa6dfcd553d01747e3649c6a77e)) - David Arnold
#### Style
- add more badges about tech stack - ([aaf0c53](https://github.com/divnix/hive/commit/aaf0c53da72ce8c1e12bce531cd79081f2984aa6)) - David Arnold
- move badges around - ([acfa7c3](https://github.com/divnix/hive/commit/acfa7c3b4429b5cf7384a2f524dc78192b6bc043)) - David Arnold
- format comment - ([7e40fb5](https://github.com/divnix/hive/commit/7e40fb52fc2f5f8af567709043954d022b3a958e)) - David Arnold
- cleanup - ([5a28836](https://github.com/divnix/hive/commit/5a28836df385242170109662c84341451e60c4ea)) - David Arnold
- treefmt - ([866219e](https://github.com/divnix/hive/commit/866219e773078edfa37e06e2f5600fcb4c20389a)) - David Arnold

- - -

Changelog generated by [cocogitto](https://github.com/cocogitto/cocogitto).