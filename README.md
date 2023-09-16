# hubble 🔭

`hubble` 🔭 is a set of tools to access and process [Hubble Space Telescope imagery](https://registry.opendata.aws/hst/) and other datasets on [AWS Open Data Registry](https://registry.opendata.aws/). 

---

```bash
hubble help
```

```bash
🔭 hubble-3.24.1

hubble download \
	[~dryrun,filename=<filename>|all,~ingest,upload] \
	[<hubble-object-name>] \
	[<object-name>]
 . hst/<hubble-object-name> -> <object-name>.
hubble list \
	[dataset] <dataset-name>
 . list <dataset-name>, example: hst.
hubble list \
	[object] <object-name>
 . list <object-name> in hst, example in hst: public/u4ge/u4ge0106r.
hubble select \
	[dataset] <dataset-name>
 . select <dataset-name>, example: hst.
hubble select \
	[object] <object-name>
 . select <object-name> in hst, example in hst: public/u4ge/u4ge0106r.
```

---
🔥
```bash
abcli select
open .
hubble select public/u4ge/u4ge0106r
hubble list .
hubble download ~dryrun,upload
```

[`./notebooks/fits.ipynb`](./notebooks/fits.ipynb)

![image](./assets/u4ge0106r_c0m.gif)

[one](https://arash-kamangir.medium.com/hubble-space-telescope-1-7857fe292698), [two](https://arash-kamangir.medium.com/hubble-space-telescope-ai-2-9282b801e25e)
