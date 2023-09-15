# hubble

Tools to access and process [Hubble Space Telescope imagery](https://registry.opendata.aws/hst/). 

---

```bash
hubble help
```

```bash
🔭 hubble-3.22.1

hubble download \
	[~dryrun,filename=<filename>|all,~ingest,upload] \
	[<hubble-object-name>] \
	[<object-name>]
 . venus-l2a-cogs/<hubble-object-name> -> <object-name>.
hubble list \
	[<dataset-name>|<object-name>]
 . list.
hubble select \
	<dataset-name>
 . select <dataset-name>, example: hst.
hubble select \
	<object-name>
 . select <object-name> in venus-l2a-cogs, example in hst: public/u4ge/u4ge0106r.
```

---

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
