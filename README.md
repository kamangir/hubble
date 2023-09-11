# hubble

Tools to access and process [Hubble Space Telescope imagery](https://registry.opendata.aws/hst/). 

To start type in,

```bash
hubble help
```

```bash
🪐 hubble-3.5.1

hubble list [.|<object-name>]
 . list hubble.
hubble select <object-name>
 . select a hubble object.

example object: public/u4ge/u4ge0106r
 ```

Example use.

```bash
abcli select
hubble select public/u4ge/u4ge0106r/
hubble list .
hubble download . .
open .
```

🔥