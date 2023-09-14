# hubble

Tools to access and process [Hubble Space Telescope imagery](https://registry.opendata.aws/hst/). 

---

```bash
hubble help
```

```bash
🪐 hubble-3.14.1

hubble download \
	[~dryrun,filename=<filename>|all,~ingest,upload] \
	[<hubble-object-name>] \
	[<object-name>]
 . <hubble-object-name> -> <object-name>.
hubble list \
	[<object-name>]
 . list hubble.
hubble select \
	<object-name>
 . select a hubble object.

example object: public/u4ge/u4ge0106r/
```

---

```bash
abcli select
open .
hubble select public/u4ge/u4ge0106r/
hubble list .
hubble download ~dryrun,upload
```

[`./notebooks/fits.ipynb`](./notebooks/fits.ipynb)

![image](./assets/u4ge0106r_c0m.gif)

[one](https://arash-kamangir.medium.com/hubble-space-telescope-1-7857fe292698), [two](https://arash-kamangir.medium.com/hubble-space-telescope-ai-2-9282b801e25e)
