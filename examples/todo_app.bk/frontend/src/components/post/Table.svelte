<script lang="ts">
  export let posts:Array<any> = []
  export let changeStatus:(id:number, status:boolean)=>void
  export let deletePost:(id:number)=>void
</script>

<style lang="scss">
  .table{
    width: 100%;
    td{
      text-align: center;
    }
    th{
      text-align: center;
    }
  }
</style>

<div class="container">
  {#if posts.length > 0}
    <table class="table is-striped">
      <tr>
        <th>title</th><th>status</th><th>delete</th>
      </tr>
      {#each posts as post}
        <tr>
          <td><a href={`./${post['id']}`}>{post['title']}</a></td>
          <td>
            <div>
              {#if post['is_finished']}
                <button type="button" on:click={changeStatus(post['id'], false)} class="button is-success is-light is-outlined">Finished</button>
              {:else}
                <button type="button" on:click={changeStatus(post['id'], true)} class="button is-danger is-light is-outlined">Not finished</button>
              {/if}
            </div>
          </td>
          <td>
            <div>
              <button type="button" on:click={deletePost(post['id'])} class="delete is-large">delete</button>
            </div>
          </td>
        </tr>
      {/each}
    </table>
  {:else}
    <p>post not found</p>
  {/if}
</div>